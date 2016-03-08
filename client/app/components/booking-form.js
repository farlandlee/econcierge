import Ember from 'ember';
import Quantity, {amountForQuantity} from 'client/models/quantity';

const {Component, computed} = Ember;

export default Component.extend({
  product: null,
  date: null,

  total: 0,
  quantities: null,
  time: null,

  canSubmit: computed('total', 'time', 'quantities.@each.quantity', 'product.prices.[]', {
    get () {
      let valid = true;
      let prices = this.get('product.prices');
      let quantities = this.get('quantities');
      let total = this.get('total');
      prices.forEach(price => {
        let amounts = price.amounts;
        let {quantity} = quantities.findBy('id', price.id);
        if (!amountForQuantity(amounts, quantity)) {
          valid = false;
        }
      });
      if (valid) {
        valid = !!this.get('time') && total > 0;
      }
      return valid;
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

    submit () {
      if (this.get('canSubmit')) {
        let properties = this.getProperties('quantities', 'time', 'date');
        return this.attrs.submit(properties);
      }
    }
  }
});
