import Ember from 'ember';

const {computed} = Ember;
const {sort, alias} = computed;

export default Ember.Component.extend({
  tagName: '',
  price: null,
  amounts: sort('price.amounts', 'byMinQuantity'),
  byMinQuantity: ['min_quantity:asc'],
  startingAmount: alias('amounts.firstObject.amount'),
});
