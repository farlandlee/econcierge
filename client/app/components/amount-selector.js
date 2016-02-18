import Ember from 'ember';

const {computed, observer} = Ember;

const {sort} = computed;

export default Ember.Component.extend({
  price: null,

  amounts: sort('price.amounts', (a, b) => a.min_quantity - b.min_quantity),

  minimum: computed('amounts.@each.min_quantity', {
    get() {
      return this.get('amounts.firstObject.min_quantity');
    }
  }),

  maximum: computed('amounts.@each.max_quantity', {
    get() {
      return this.get('amounts.lastObject.max_quantity');
    }
  }),

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

  didInsertElement() {
    // updating the cost changes the what's being rendered,
    // which you shouldn't do in didInsertElement. So,
    // run it in the next loop
    Ember.run.next(this, this._updateCost);
  },

  _updateCost: observer('quantity', 'amounts.@each.amount', 'price.id', function () {
    let {amounts, quantity, price} = this.getProperties('amounts', 'quantity', 'price');

    let amount = amounts.find(({min_quantity, max_quantity}) => {
      return quantity >= min_quantity &&
        (max_quantity === 0 || quantity <= max_quantity);
    });

    let cost = amount.amount * quantity;

    return this.attrs.updateCost(price, cost);
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
