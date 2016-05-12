import Ember from 'ember';
import NotFoundMixin from 'client/mixins/not-found';
import RouteTitleMixin from 'client/mixins/route-title';

export default Ember.Route.extend(NotFoundMixin, RouteTitleMixin, {
  titleToken (activity) {
    return activity.get('name');
  },

  model ({activity_slug}) {
    let activities = this.store.peekAll('activity');
    let activity = activities.findBy('slug', activity_slug);
    if (!activity) {
      console.error("Activity not found");
      return this.throwNotFound();
    }
    return activity;
  },

  serialize (activity) {
    return {activity_slug: activity.get('slug')};
  }
});
