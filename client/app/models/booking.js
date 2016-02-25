import DS from 'ember-data';
import Ember from 'ember';
import {amountForQuantity} from 'client/models/quantity';

const {computed} = Ember;

export default DS.Model.extend({
  product: DS.belongsTo('product'),
  // through product... stored here so we don't have to chain preloads, can do them all at once
  activity: DS.belongsTo('activity'),
  experience: DS.belongsTo('experience'),
  category: DS.belongsTo('category'),
  date: DS.attr(),
  // {id: id, time: string}
  startTime: DS.attr(),
  // list of {id: price.id, quantity: integer}
  quantities: DS.attr(),

  total: computed('quantities.@each.{quantity,id}', {
    get () {
      let product = this.get('product');
      if (!product.get('isLoaded')) {
        throw `
        Lazy loading is evil.
        Make sure you preloaded this booking's product if you need its total.
        `;
      }
      
      let prices = product.get('prices');
      let quantities = this.get('quantities');
      let total = 0;

      quantities.forEach(({id, quantity}) => {
        let amounts = prices.findBy('id', id).amounts;
        let amount = amountForQuantity(amounts, quantity);
        let cost = amount.amount * quantity;
        total += cost;
      });

      return total;
    }
  })
});
