import Ember from 'ember';
import DS from 'ember-data';

const {computed} = Ember;

export default DS.Model.extend({
  name: DS.attr(),
  description: DS.attr(),
  slug: DS.attr(),
  activity: DS.belongsTo('activity'),
  experiences: DS.hasMany('experience'),
  defaultExperience: DS.belongsTo('experience', {inverse: null}),
  image: DS.attr(),
  defaultImage: computed.alias('image')
});
