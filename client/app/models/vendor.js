import DS from 'ember-data';
import Ember from 'ember';

const {computed} = Ember;

export default DS.Model.extend({
  name: DS.attr(),
  description: DS.attr(),
  slug: DS.attr(),
  cancellationPolicyDays: DS.attr('number'),
  tripadvisorUrl: DS.attr(),
  tripadvisorReviewUrl: DS.attr(),
  tripadvisorRating: DS.attr(),
  tripadvisorRatingImageUrl: DS.attr(),
  tripadvisorReviewsCount: DS.attr(),
  defaultImage: DS.attr(),

  hasTripadvisor: computed('tripadvisorUrl','tripadvisorReviewUrl', {
    get() {
      let url = this.get('tripadvisorUrl');
      let reviewUrl = this.get('tripadvisorReviewUrl');

      return url && reviewUrl;
    }
  })
});
