import DS from 'ember-data';
import Ember from 'ember';

const {
  computed: {alias}
} = Ember;

export default DS.Model.extend({
  name: DS.attr(),
  description: DS.attr(),
  slug: DS.attr(),
  cancellationPolicyDays: DS.attr('number'),
  tripadvisorRating: DS.attr(),
  defaultImage: DS.attr(),
  image: alias('defaultImage')
});
