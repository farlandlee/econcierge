import Ember from 'ember';

const {computed} = Ember;

export default Ember.Controller.extend({
  queryParams: [
    {vendorFilter: 'vendor'},
    {sort: 'sort'}
  ],

  vendorFilter: [],
  sort: 'Price',

  sortFieldToString: {
    "Price" : ["minDefaultPrice:asc"],
    "Rating" : ["vendor.tripadvisorRating:desc"],
    "Trip Name" : ["name:asc"],
    "Trip Duration" : ["duration:asc"]
  },

  // route assigned properties
  experienceName: null,
  products: null,
  date: null,
  displayFilter: false,
  displaySort: false,

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

      return vendors;
    }
  }),

  filteredProducts: computed('products.@each.vendor', 'vendorFilter.[]', {
    get () {
      let products = this.get('products');
      let vendorFilter = this.get('vendorFilter');
      if (vendorFilter && vendorFilter.length) {
        products = products.filter(p => vendorFilter.contains(p.get('vendor.slug')));
      }
      return products;
    }
  }),

  currentSortOrder: computed('sort', 'sortFieldToString', {
    get() {
      let sortField = this.get('sort');
      return this.get('sortFieldToString')[sortField];
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

    toggleFilter (filterName, value) {
      let filter = this.get(filterName);
      if (filter.contains(value)) {
        filter.removeObject(value);
      } else {
        filter.pushObject(value);
      }
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
