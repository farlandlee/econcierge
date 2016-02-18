import Ember from 'ember';

export default Ember.Component.extend({
  product: null,

  cost: 0,
  costs: null,

  init () {
    this._super(...arguments);
    this.set('costs', {});
  },

  actions: {
    updateCost (price, amount) {
      let costs = this.get('costs');
      costs[price.id] = amount;

      let cost = 0;
      for (const id in costs) {
        cost += costs[id];
      }

      this.set('cost', cost);
      this.set('costs', costs);
    },

    submit () {
      //@TODO #241
    }
  }
});
