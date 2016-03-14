import Ember from 'ember';
import {amountForQuantity} from 'client/models/quantity';

const {computed} = Ember;

const {sort, alias} = computed;

export default Ember.Component.extend({
  tagName: '',
  showAmountLabel: false,

  price: null,
  quantities: null,


  amounts: sort('price.amounts', 'minQuantityAscending'),
  minQuantityAscending: ['min_quantity:asc'],
  minimum: alias('amounts.firstObject.min_quantity'),
  maximum: alias('amounts.lastObject.max_quantity'),
  // purposefully leaving 'quantities.@each.quantity' out of dependent keys,
  // as it should only ever be read from once
  quantity: computed('minimum', 'maximum', {
    get() {
      let quantities = this.get('quantities');
      let {quantity} = quantities.findBy('id', this.get('price.id'));
      let validatedQuantity = this._validateQuantityValue(quantity);
      if (quantity !== validatedQuantity) {
        this._onChange(validatedQuantity);
      }
      return validatedQuantity;
    },
    set (_key, value) {
      value = this._validateQuantityValue(value);
      this._onChange(value);
      return value;
    }
  }),

  cost: computed('quantity', {
    get () {
      let {quantity, amounts} = this.getProperties('quantity', 'amounts');
      let {amount} = amountForQuantity(amounts, quantity);
      return amount * quantity;
    }
  }),

  amount: computed('quantity', 'amounts.@each.{min_quantity,max_quantity}', {
    get () {
      let quantity = this.get('quantity');
      let amounts = this.get('amounts');
      return amountForQuantity(amounts, quantity);
    }
  }),

  _onChange (quantity) {
    // Can't just `get('amount')` because that triggers an infinite loop.
    // Just recalculating it isn't that big of a deal.
    let amounts = this.get('amounts');
    let amount = amountForQuantity(amounts, quantity);
    return this.attrs.onChange(amount, quantity);
  },

  _validateQuantityValue (value) {
    let {minimum, maximum} = this.getProperties('minimum', 'maximum');
    if (value < minimum) {
      return minimum;
    }
    if (maximum && value > maximum) {
      return maximum;
    }
    return value;
  },

  actions: {
    increment () {
      this.incrementProperty('quantity', 1);
    },
    decrement () {
      this.incrementProperty('quantity', -1);
    }
  }
});
