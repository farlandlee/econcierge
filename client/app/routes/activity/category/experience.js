import Ember from 'ember';

export default Ember.Route.extend({
  model (params) {
    return this.store.query('experience', {
      date: params.date,
      activity_id: this.modelFor('activity').id,
      category_id: this.modelFor('activity.category').id
    });
  }
});
