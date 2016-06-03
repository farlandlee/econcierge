import Ember from 'ember';
import {
  formatTime, format,
  startTimeAvailableForDate
} from 'client/utils/time';
import {sortFieldToString} from 'client/components/product-sorter';
import {toSet, flatten} from 'client/utils/fn';

const {
  $,
  computed,
  observer,
  isEmpty,
  run: {throttle}
} = Ember;

// See the 'times' property
const arbitraryTimes = [
  {
    name: 'Morning (5:00AM - 11:30AM)',
    value: 'morning',
    start: '05:00:00',
    end: '11:30:00'
  },
  {
    name: 'Afternoon (12:00PM - 4:00PM)',
    value: 'afternoon',
    start: '12:00:00',
    end: '16:00:00'
  },
  {
    name: 'Evening (5:00PM - 6:00PM)',
    value: 'evening',
    start: '17:00:00',
    end: '18:00:00'
  }
];

const inArbitraryTime = ({start, end}) => {
  return (productTime) => {
    // could be an object with a string value or just that string value
    productTime = productTime.value || productTime;
    return productTime >= start && productTime <= end;
  };
};

export default Ember.Controller.extend({
  queryParams: [
    {timeFilter: 'time'},
    {amenityOptionFilter: 'amenity'},
    {vendorFilter: 'vendor'},
    'sort',
    'date'
  ],

  sort: 'Price',
  displaySort: false,
  displayFilterSort: false,

  // route assigned properties
  products: null,
  date: null,

  /* the set of vendors whose products are on display */
  vendors: computed('products.@each.vendor', {
    get () {
      let vendors = this.get('products').mapBy('vendor');
      vendors = vendors.mapBy('id')
        .reduce(toSet, [])
        .map(id => vendors.findBy('id', id));
      this._cleanVendorFilter(vendors);
      return vendors;
    }
  }),

  /* the activity amenities filtered down to just those for this product set */
  amenities: computed('activity.amenities.[]', 'products.[]', {
    get () {
      let productOptions = this.get('products')
        .mapBy('amenityOptions')
        .reduce(flatten, []); // has dupes, but that's OK! we're just using it for filtering

      return this.get('activity.amenities').map(({id, name, options}) => {
        // filter the options down to those represented by product options
        options = options.filter(o => {
          return productOptions.contains(o.id);
        });
        return {id, name, options};
        // and filter the amenities down as well!
      }).reject(amenity => isEmpty(amenity.options));
    }
  }),

  /* all amenity options. also validates query params as side effect */
  amenityOptions: computed('amenities.@each.options', {
    get () {
      let amenityOptions = this.get('amenities')
        .mapBy('options')
        .reduce(flatten, []);
      this._cleanAmenityOptionFilter(amenityOptions);
      return amenityOptions;
    }
  }),

  arbitraryTimes: computed('times.@each.value', {
    get () {
      let times = this.get('times');
      let isApplicableArbitraryTime = (arbitraryTime) => {
        let inThisArbitraryTime = inArbitraryTime(arbitraryTime);
        return times.any(inThisArbitraryTime) && !times.every(inThisArbitraryTime);
      };

      let aTimes = arbitraryTimes.filter(isApplicableArbitraryTime);
      this._cleanTimeFilter(times.concat(aTimes));
      return aTimes;
    }
  }),

  times: computed('products.@each.startTimes', {
    get () {
      let toTimeFilter = (t) => {
        return {
          name: formatTime(t),
          value: t
        };
      };

      let times = this.get('products')
        .mapBy('startTimes')
        .reduce(flatten, [])
        .mapBy('starts_at_time')
        .reduce(toSet, [])
        .map(toTimeFilter)
        .sortBy('value');

      return times;
    }
  }),

  // [vendorSlug, vendorSlug, ...]
  vendorFilter: [],
  // [amenityOptionId, amenityOptionId, ...]
  amenityOptionFilter: [],
  // ["00:00:00", "13:37:00", ...]
  timeFilter: [],

  _cleanVendorFilter (vendors) {
    let validSlugs = vendors.mapBy('slug');
    let vendorFilter = this.get('vendorFilter');
    vendorFilter = vendorFilter.filter(slug => validSlugs.contains(slug));
    this.set('vendorFilter', vendorFilter);
  },

  _cleanAmenityOptionFilter (amenityOptions) {
    let validIds = amenityOptions.mapBy('id');
    let amenityOptionFilter = this.get('amenityOptionFilter');
    amenityOptionFilter = amenityOptionFilter.filter(id => validIds.contains(id));
    this.set('amenityOptionFilter', amenityOptionFilter);
  },

  _cleanTimeFilter (times) {
    let validTimes = times.mapBy('value');
    let timeFilter = this.get('timeFilter');
    timeFilter = timeFilter.filter(time => validTimes.contains(time));
    this.set('timeFilter', timeFilter);
  },

  _updatedFilters: observer('dateFilteredProducts.[]', function () {
    throttle(this, this._resetProductScroll, 200);
  }),

  _resetProductScroll () {
    $('.explore-right').animate({scrollTop: 0}, 'fast');
  },

  filteredProducts: computed('products.[]', 'vendorFilter.[]', 'amenityOptionFilter.[]', 'timeFilter.[]', 'date', {
    get () {
      let filters = this.getProperties('vendorFilter', 'amenityOptionFilter', 'timeFilter');
      let products = this.get('products');
      let filterFns = [];

      // @TODO would be useful to abstract filters and have them be services that we
      // call on to filter things down perhaps, hmmm?
      if (filters.vendorFilter.length) {
        let {vendorFilter} = filters;
        filterFns.pushObject(p => vendorFilter.contains(p.get('vendor.slug')));
      }

      if (filters.amenityOptionFilter.length) {
        let {amenityOptionFilter} = filters;
        // This filter is complex, as each amenity is filtered individually.
        // So, amenity filters act as an AND across amenities,
        // but an OR across an amenity's options.
        // (raft-size == 4 OR 8) AND (meal == lunch OR dinner)
        let amenityFilters = this.get('amenities').map(({options}) => {
          return options.filter(({id}) => {
            return amenityOptionFilter.contains(id);
          });
        }).reject(isEmpty);

        filterFns.pushObject(p => {
          let productOptions = p.get('amenityOptions');
          return amenityFilters.every(options => {
            return options.any(o => productOptions.contains(o.id));
          });
        });
      }

      if (filters.timeFilter.length) {
        let {timeFilter} = filters;
        filterFns.pushObject(p => {
          let times = p.get('startTimes').mapBy('starts_at_time');

          return timeFilter.any(t => {
            let arbitraryTime = arbitraryTimes.findBy('value', t);
            if (arbitraryTime) {
              return times.any(inArbitraryTime(arbitraryTime));
            } else {
              return times.contains(t);
            }
          });
        });
      }

      return products.filter(p => filterFns.every(f => f(p)));
    }
  }),

  dateFilteredProducts: computed('filteredProducts.[]', 'date', {
    get () {
      let date = this.get('date');
      let filteredProducts = this.get('filteredProducts');

      if (date) {
        let availableOnDate = startTimeAvailableForDate(date);
        return filteredProducts.filter(p => p.get('startTimes').any(availableOnDate));
      }

      return filteredProducts;
    }
  }),

  isFiltering: computed('date', 'vendorFilter.[]', 'amenityOptionFilter.[]', 'timeFilter.[]', {
    get () {
      if (this.get('date')) {
        return true;
      }
      return ['vendorFilter', 'amenityOptionFilter', 'timeFilter']
        .any(filterName => !isEmpty(this.get(filterName)));
    }
  }),

  currentSortOrder: computed('sort', {
    get() {
      let sortField = this.get('sort');
      return sortFieldToString[sortField];
    }
  }),

  actions: {
    clearFilter (filterName) {
      this.set(filterName, []);
    },

    clearAmenityFilter (amenity) {
      let amenityOptionFilter = this.get('amenityOptionFilter');
      let optionsToClear = amenity.options.mapBy('id');

      amenityOptionFilter = amenityOptionFilter.reject(id => {
        return optionsToClear.contains(id);
      });

      this.setProperties({amenityOptionFilter});
    },

    toggleFilter (filter, value) {
      if (filter.contains(value)) {
        filter.removeObject(value);
      } else {
        filter.pushObject(value);
      }
    },

    hideSort (sortControl) {
      this.set(sortControl, false);
    },

    toggleDisplaySort (sortControl) {
      event.preventDefault();
      this.toggleProperty(sortControl);
    },

    updateSortParam (sortControl, value) {
      this.set('sort', value);
      this.toggleProperty(sortControl); // hide dropdown after click
    },

    changeDate (date) {
      if (date) {
        date = format(date);
      }
      this.set('date', date);
    },

    clearFilters () {
      this.setProperties({
        displayFilter: '',
        vendorFilter: [],
        amenityOptionFilter: [],
        timeFilter: [],
        date: null
      });
    },

    openFilters () {
      $('.explore-left').addClass('open').scrollTop(0);
    },

    closeFilters () {
      $('.explore-left').removeClass('open');
      $('body').css('overflow','auto');
    }
  }
});
