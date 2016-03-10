import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr(),
  description: DS.attr(),
  slug: DS.attr(),
  activity: DS.belongsTo('activity'),
  experiences: DS.hasMany('experience'),
  defaultExperience: DS.belongsTo('experience', {inverse: null}),
  image: DS.attr()
});
