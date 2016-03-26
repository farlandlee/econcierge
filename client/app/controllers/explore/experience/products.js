import Ember from 'ember';

const {computed} = Ember;

export default Ember.Controller.extend({
  queryParams: [
    {vendorFilter: 'vendor'}
  ],

  vendorFilter: [],

  // route assigned properties
  experienceName: null,
  products: null,
  date: null,
  displayFilter: false,
  vendors: null,

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
    }
  }
});
