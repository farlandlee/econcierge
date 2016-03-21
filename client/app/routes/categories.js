import Ember from 'ember';
import NotFoundMixin from 'client/mixins/not-found';
import ResetScrollMixin from 'client/mixins/reset-scroll';
import RouteTitleMixin from 'client/mixins/route-title';
import RouteDescriptionMixin from 'client/mixins/route-meta-description';

export default Ember.Route.extend(NotFoundMixin, ResetScrollMixin, RouteTitleMixin, RouteDescriptionMixin, {
  titleToken ({activity}) {
    return [activity.get('name'), "Activities"];
  },

  description ({activity}) {
    return activity.get('description');
  },

  model (params) {
    let {activity_slug} = params;
    let activities = this.store.peekAll('activity');
    let activity = activities.findBy('slug', activity_slug);

    if (!activity) {
      return this.throwNotFound();
    }

    let categories = this.store.query('category', {
      activity_id: activity.get('id')
    });

    return Ember.RSVP.hash({
      activity: activity,
      categories: categories
    });
  },

  afterModel ({categories, activity}) {
    // if there's only one category for the activity,
    // immediately select that category
    if (categories.get('length') === 1) {
      let activitySlug = activity.get('slug');
      let categorySlug = categories.get('firstObject.slug');
      this.replaceWith('explore', activitySlug, categorySlug);
    }
  },

  setupController (controller, model) {
    this._super(...arguments);
    controller.setProperties(model);
    controller.set('activities', this.store.peekAll('activity'));
  }
});
