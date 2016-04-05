import Ember from 'ember';

const {computed, isEmpty} = Ember;

const flatten = (flattened, arr) => {
  arr.forEach(x => flattened.pushObject(x));
  return flattened;
};

export const sortFieldToString = {
  "Price" : ["minDefaultPrice:asc"],
  "Rating" : ["vendor.tripadvisorRating:desc"],
  "Trip Name" : ["name:asc"],
  "Trip Duration" : ["duration:asc"]
};

export default Ember.Controller.extend({
  queryParams: [
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

  /* all amenity options. useful for mapping amenityOptionFilter -> amenityOption */
  amenityOptions: computed('amenities.@each.options', {
    get () {
      let amenityOptions = this.get('amenities')
        .mapBy('options')
        .reduce(flatten, []);
      this._cleanAmenityOptionFilter(amenityOptions);
      return amenityOptions;
    }
  }),

  // 'vendor' || {{amenity.name}} || ''
  displayFilter: '',
  // [vendorSlug, vendorSlug, ...]
  vendorFilter: [],
  // [amenityOptionId, amenityOptionId, ...]
  amenityOptionFilter: [],

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

  filteredProducts: computed('products.[]', 'vendorFilter.[]', 'amenityOptionFilter.[]', {
    get () {
      let {vendorFilter, amenityOptionFilter, products} =
        this.getProperties('vendorFilter', 'amenityOptionFilter', 'products');

      // @TODO would be useful to abstract filters and have them be services that we
      // call on to filter things down perhaps, hmmm?
      if (vendorFilter && vendorFilter.length) {
        products = products.filter(p => vendorFilter.contains(p.get('vendor.slug')));
      }

      if (amenityOptionFilter && amenityOptionFilter.length) {
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

      return products;
    }
  }),

  filtering: computed('vendorFilter.[]', 'amenityOptionFilter.[]', {
    get () {
      let {vendorFilter, amenityOptionFilter} = this.getProperties('vendorFilter', 'amenityOptionFilter');
      return !isEmpty(vendorFilter) || !isEmpty(amenityOptionFilter);
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
