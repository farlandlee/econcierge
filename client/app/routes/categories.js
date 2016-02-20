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

  setupController (controller, model) {
    this._super(...arguments);
    controller.setProperties(model);
  },

  actions: {
    dateForCategory (category) {
      let activitySlug = this.controller.get('activity.slug');
      let categorySlug = category.get('slug');
      return Ember.$.getJSON(`/web_api/date/${activitySlug}/${categorySlug}`)
      .then(response => {
        let date = response.date;
        this.transitionTo('explore', activitySlug, categorySlug, date);
      });
    }
  }
});
