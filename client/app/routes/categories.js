import Ember from 'ember';
import NotFoundMixin from 'client/mixins/not-found';

export default Ember.Route.extend(NotFoundMixin, {
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
      activities: activities,
      categories: categories
    });
  },

  afterModel ({categories, activity}) {
    // if there's only one category for the activity,
    // immediately transition to experienes
    if (categories.get('length') === 1) {
      let activitySlug = activity.get('slug');
      let categorySlug = categories.get('firstObject.slug');
      return this._dateForCategory(activitySlug, categorySlug);
    }
  },

  setupController (controller, model) {
    this._super(...arguments);
    controller.setProperties(model);
  },

  _dateForCategory(activitySlug, categorySlug) {
    let dateApiUrl = `/web_api/date/${activitySlug}/${categorySlug}`;
    return Ember.$.getJSON(dateApiUrl).then(response => {
      let date = response.date;
      return this.transitionTo('explore', activitySlug, categorySlug, date);
    });
  },

  actions: {
    dateForCategory (category) {
      let activitySlug = this.controller.get('activity.slug');
      let categorySlug = category.get('slug');
      this._dateForCategory(activitySlug, categorySlug);
    }
  }
});
