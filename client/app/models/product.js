import DS from 'ember-data';

export default DS.Model.extend({
  description: DS.attr(),
  name: DS.attr(),
  pickup: DS.attr('boolean'),
  duration: DS.attr('number'),
  /* @TODO these need to be impl'd as models */
  meetingLocation: DS.attr(),
  defaultPrice: DS.attr('number'),
  vendor: DS.belongsTo('vendor'),
  prices: DS.attr(),
  startTimes: DS.attr()
});
