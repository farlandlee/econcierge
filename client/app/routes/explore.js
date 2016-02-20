import Ember from 'ember';
import NotFoundMixin from 'client/mixins/not-found';
import moment from 'moment';

export default Ember.Route.extend(NotFoundMixin, {
  model (params) {
    let {date, activity_slug, category_slug} = params;
    let activities = this.store.peekAll('activity');
    let activity = activities.findBy('slug', activity_slug);
    
    if (!activity) {
      return this.throwNotFound();
    }

    let categoriesQuery = this.store.query('category', {
      activity_id: activity.get('id')
    });

    return Ember.RSVP.hash({
      activity: activity,
      categories: categoriesQuery
    }).then(({activity, categories}) => {
      let category = categories.findBy('slug', category_slug);
      if (!category) {
        return this.throwNotFound();
      }

      let experiencesQuery = this.store.query('experience', {
        activity_id: activity.get('id'),
        category_id: category.get('id')
      });

      return Ember.RSVP.hash({
        activity: activity,
        category: category,
        experiences: experiencesQuery,
        date: date
      });
    });
  },

  setupController(controller, model) {
    this._super(...arguments);
    controller.setProperties(model);
  },

  actions: {
    changeDate: function (date) {
      let {activity, category} = this.controller.model;
      this.transitionTo('explore', activity.get('slug'), category.get('slug'), moment(date).format('YYYY-MM-DD'));
    }
  }
});
