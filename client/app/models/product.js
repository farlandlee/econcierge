import DS from 'ember-data';

export let amountForQuantity = function (amounts, quantity) {
  return amounts.find(({min_quantity, max_quantity}) => {
    return quantity >= min_quantity &&
    (max_quantity === 0 || quantity <= max_quantity);
  });
};

export default DS.Model.extend({
  description: DS.attr(),
  name: DS.attr(),
  pickup: DS.attr('boolean'),
  duration: DS.attr('number'),
  defaultPrice: DS.attr(),

  vendor: DS.belongsTo('vendor'),
  experience: DS.belongsTo('experience'),

  meetingLocation: DS.attr(),
  prices: DS.attr(),
  startTimes: DS.attr()
});
