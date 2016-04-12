import Ember from 'ember';
import {formatTime} from 'client/utils/time';

const {computed, isEmpty} = Ember;

const toSet = (set, value) => {
  if (!set.contains(value)) {
    set.pushObject(value);
  }
  return set;
};

const flatten = (flattened, arr) => {
  arr.forEach(x => flattened.pushObject(x));
  return flattened;
};

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

export const sortFieldToString = {
  "Price" : ["minDefaultPrice:asc"],
  "Rating" : ["vendor.tripadvisorRating:desc"],
  "Trip Name" : ["name:asc"],
  "Trip Duration" : ["duration:asc"]
};

export default Ember.Controller.extend({
  queryParams: [
    {timeFilter: 'time'},
    {amenityOptionFilter: 'amenity'},
    {vendorFilter: 'vendor'},
    {sort: 'sort'}
  ],

  sort: 'Price',
  displaySort: false,

  // route assigned properties
  experienceName: null,
  products: null,
  date: null,
  // all possible amenities for this activity
  activityAmenities: null,

  /* the set of vendors whose products are on display */
  vendors: computed('products.@each.vendor', {
    get () {
      let products = this.get('products');
      let vendors = [];
      let seenVendors = {};

      let addToSet = (vendor => {
        let id = vendor.get('id');
        if (!seenVendors[id]) {
          seenVendors[id] = true;
          vendors.pushObject(vendor);
        }
      });

      products.mapBy('vendor').forEach(addToSet);
      this._cleanVendorFilter(vendors);
      return vendors;
    }
  }),

  /* the activity amenities filtered down to just those for this product set */
  amenities: computed('activityAmenities.[]', 'products.[]', {
    get () {
      let productOptions = this.get('products')
        .mapBy('amenityOptions')
        .reduce(flatten, []); // has dupes, but that's OK! we're just using it for filtering

      return this.get('activityAmenities').map(({id, name, options}) => {
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

      times = arbitraryTimes.filter(t => times.any(inArbitraryTime(t))).concat(times);
      this._cleanTimeFilter(times);
      return times;
    }
  }),

  // 'vendor' || {{amenity.name}} || 'time' || ''
  displayFilter: '',
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

  filteredProducts: computed('products.[]', 'vendorFilter.[]', 'amenityOptionFilter.[]', 'timeFilter.[]', {
    get () {
      let filters = this.getProperties('vendorFilter', 'amenityOptionFilter', 'timeFilter');
      let products = this.get('products');

      // @TODO would be useful to abstract filters and have them be services that we
      // call on to filter things down perhaps, hmmm?
      if (filters.vendorFilter.length) {
        let {vendorFilter} = filters;
        products = products.filter(p => vendorFilter.contains(p.get('vendor.slug')));
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

        products = products.filter(p => {
          let productOptions = p.get('amenityOptions');
          return amenityFilters.every(options => {
            return options.any(o => productOptions.contains(o.id));
          });
        });
      }

      if (filters.timeFilter.length) {
        let {timeFilter} = filters;
        products = products.filter(p => {
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

      return products;
    }
  }),

  isFiltering: computed('vendorFilter.[]', 'amenityOptionFilter.[]', 'timeFilter.[]', {
    get () {
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
    hideFilter (filter) {
      let current = this.get('displayFilter');
      if (current === filter) {
        this.set('displayFilter', null);
      }
    },

    toggleDisplayFilter (filter, event) {
      event.preventDefault(); // stop it foundation!
      let current = this.get('displayFilter');
      if (current === filter) {
        this.set('displayFilter', null);
      } else {
        this.set('displayFilter', filter);
      }
    },

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

    removeFilter (filter, value) {
      filter.removeObject(value);
    },

    hideSort () {
      this.set('displaySort', false);
    },

    toggleDisplaySort () {
      event.preventDefault();
      this.toggleProperty('displaySort');
    },

    updateSortParam (value) {
      this.set('sort', value);
      this.toggleProperty('displaySort'); // hide dropdown after click
    }
  }
});
