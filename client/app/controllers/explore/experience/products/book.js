import Ember from 'ember';

const {
  inject,
  computed
} = Ember;

export default Ember.Controller.extend({
  productsController: inject.controller('explore/experience/products'),
  // essentially a one way binding on products.date
  date: computed('productsController.date', {
    get () {
      return this.get('productsController.date');
    },
    set (_k, value) {
      return value;
    }
  })
});
