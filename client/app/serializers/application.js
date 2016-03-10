import DS from 'ember-data';
import Ember from 'ember';

export default DS.RESTSerializer.extend({
  keyForAttribute (attr) {
    return Ember.String.underscore(attr);
  },
  
  keyForRelationship (relationship) {
    return Ember.String.underscore(relationship);
  }
});
