import DS from 'ember-data';

export default DS.Model.extend({
  product: DS.belongsTo('product'),
  date: DS.attr(),
  // {id: id, time: string}
  startTime: DS.attr(),
  // list of {id: price.id, quantity: integer}
  quantities: DS.attr()
});
