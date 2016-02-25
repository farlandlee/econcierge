import DS from 'ember-data';

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
