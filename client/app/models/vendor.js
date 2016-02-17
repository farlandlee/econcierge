import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr(),
  description: DS.attr(),
  slug: DS.attr(),
  cancellationPolicyDays: DS.attr('number'),
  tripadvisorUrl: DS.attr(),
  tripadvisorRating: DS.attr(),
  tripadvisorRatingImageUrl: DS.attr(),
  tripadvisorReviewsCount: DS.attr(),
  defaultImage: DS.attr()
});
