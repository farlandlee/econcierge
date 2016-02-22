import Ember from 'ember';

export default Ember.Component.extend({
  product: null,

  total: 0,
  // mapping from price to {quantity, cost}
  costs: null,
  time: null,

  init () {
    this._super(...arguments);
    this.set('costs', {});
  },

  actions: {
    updateQuantity (price, amount, quantity) {
      let costs = this.get('costs');
      let cost = amount.amount * quantity;
      costs[price.id] = {quantity, cost};

      let total = 0;
      for (const id in costs) {
        total += costs[id].cost;
      }

      this.set('total', total);
      this.set('costs', costs);
    },

    updateTime (time) {
      this.set('time', time);
    },

    submit () {
      let costs = this.get('costs');
      let time = this.get('time');
      this.attrs.submit(costs, time);
    }
  }
});
