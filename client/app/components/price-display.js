import Ember from 'ember';

const {computed} = Ember;

const {sort} = computed;

export default Ember.Component.extend({
  tagName: '',
  price: null,
  amounts: sort('price.amounts', (a, b) => a.min_quantity - b.min_quantity)
});
