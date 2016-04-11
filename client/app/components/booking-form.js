import Ember from 'ember';
import Quantity, {amountForQuantity} from 'client/models/quantity';

const {Component, computed} = Ember;

export default Component.extend({
  product: null,
  date: null,

  step: 0,
  total: 0,
  quantities: null,
  time: null,

  canProceed: computed('step', 'total', 'time', 'quantities.@each.quantity', 'product.prices.[]', {
    get () {
      if (!this.get('total')) {
        return false;
      }

      let step = this.get('step');
      // All prices have valid quantities
      if (step === 0) {
        let quantities = this.get('quantities');
        let priceHasValidQuantity = (price) => {
          let {amounts, id} = price;
          let {quantity} = quantities.findBy('id', id);
          return !!amountForQuantity(amounts, quantity);
        };
        return this.get('product.prices').every(priceHasValidQuantity);
      } else {
        // Choose a date and time (step 1)
        return !!this.get('date') && !!this.get('time');
      }
    }
  }),

  init () {
    this._super(...arguments);
    let quantities = this.get('product.prices').map(p => {
      return Quantity.create({
        id: p.id,
        quantity: 0,
        cost: 0
      });
    });
    this.set('quantities', quantities);
  },

  actions: {
    updateQuantity (price, amount, quantity) {
      let cost = amount.amount * quantity;
      let quantities = this.get('quantities');
      let priceQuantity = quantities.findBy('id', price.id);
      priceQuantity.setProperties({cost, quantity});

      let total = quantities.mapBy('cost')
        .reduce((total, cost) => total + cost, 0);

      this.set('total', total);
      this.set('quantities', quantities);
    },

    updateTime (time) {
      this.set('time', time);
    },

    next () {
      if (this.get('canProceed')) {
        let step = this.get('step');
        if (step === 0) {
          this.incrementProperty('step');
        }
        if (step === 1) {
          let properties = this.getProperties('quantities', 'time', 'date');
          this.attrs.submit(properties);
        }
      }
    },

    previous () {
      let step = this.incrementProperty('step', -1);
      if (step < 0) {
        this.attrs.cancel();
      }
    }
  }
});
