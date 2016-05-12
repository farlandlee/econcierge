import Ember from 'ember';

export default Ember.Route.extend({
  model ({activity_slug, product_id}) {
    return this.transitionTo('activity.product', activity_slug, product_id);
  }
});
