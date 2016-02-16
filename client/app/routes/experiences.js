import Ember from 'ember';

export default Ember.Route.extend({
  model (params) {
    let {date, activity_slug, category_slug} = params;
    return this.store.findAll('activity').then(activities => {
      let activity = activities.findBy('slug', activity_slug);
      if (!activity) {
        throw 'Activity not found';
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
        throw 'Category not found';
      }

      let experiencesQuery = this.store.query('experience', {
        date: date,
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
