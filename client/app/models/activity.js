import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr(),
  description: DS.attr(),
  slug: DS.attr(),
  categories: DS.hasMany('category'),
  defaultImage: DS.attr()
});
