import DS from 'ember-data';
import Ember from 'ember';

const {computed: {alias}} = Ember;

export default DS.Model.extend({
  name: DS.attr(),
  description: DS.attr(),
  slug: DS.attr(),
  categories: DS.hasMany('category'),
  defaultImage: DS.attr(),
  image: alias('defaultImage'),
  // [{id, name, options: [{id, name}]}]
  amenities: DS.attr(),
  useProductPhotoCard: DS.attr(),
});
