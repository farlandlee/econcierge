import Ember from 'ember';

const {computed, observer} = Ember;

const {sort, alias} = computed;

export default Ember.Component.extend({
  price: null,

  amounts: null,
  sortedAmounts: sort('amounts', 'minQuantityAscending'),
  minQuantityAscending: ['min_quantity:asc'],

  minimum: alias('sortedAmounts.firstObject.min_quantity'),
  maximum: alias('sortedAmounts.lastObject.max_quantity'),
  quantity: computed('minimum', 'maximum', {
    get() {
      return this.get('minimum');
    },
    set (_key, value) {
      let {minimum, maximum} = this.getProperties('minimum', 'maximum');
      if (value < minimum) {
        return minimum;
      }
      if (maximum && value > maximum) {
        return maximum;
      }
      return value;
    }
  }),

  _onChange: observer('quantity', 'amounts.@each.{min_quantity,max_quantity,amount}', function () {
    let quantity = this.get('quantity');
    let amount = this.get('amounts')
      .find(({min_quantity, max_quantity}) => {
        return quantity >= min_quantity &&
        (max_quantity === 0 || quantity <= max_quantity);
      });

    return this.attrs.onChange(amount, quantity);
  }),

  actions: {
    increment () {
      this.incrementProperty('quantity', 1);
    },
    decrement () {
      this.incrementProperty('quantity', -1);
    }
  }
});
