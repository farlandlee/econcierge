import Ember from 'ember';

export default Ember.Route.extend({
  model (params) {
    let date = params.date;
    let activitySlug = params.activity_slug;
    let categorySlug = params.category_slug;
    return Ember.RSVP.hash({
      activity: this._getBySlug('activity', activitySlug),
      category: this._getBySlug('category', categorySlug)
    }).then(({activity, category}) => {
      let experiences = this.store.query('experience', {
        date: date,
        activity_id: activity.get('id'),
        category_id: category.get('id')
      });

      return Ember.RSVP.hash({
        activity: activity,
        category: category,
        experiences: experiences
      });
    });
  },

  setupController(controller, model) {
    this._super(...arguments);
    controller.setProperties(model);
  },

  _getBySlug(model, slug) {
    return this.store.findAll(model).then(models => {
      return models.findBy('slug', slug);
    });
  }
});
