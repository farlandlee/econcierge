import Ember from 'ember';
import NotFoundMixin from 'client/mixins/not-found-mixin';

export default Ember.Route.extend(NotFoundMixin, {
  model (params) {
    let {date, activity_slug, category_slug} = params;

    return this.store.findAll('activity').then(activities => {
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
      });
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
  }
});
