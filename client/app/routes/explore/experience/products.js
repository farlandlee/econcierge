import Ember from 'ember';

export default Ember.Route.extend({
  model () {
    let experience = this.modelFor('explore.experience');
    let date = this.modelFor('explore').date;
    return this.store.query('product', {
      experience_id: experience.id,
      date: date
    });
  },

  setupController (controller, model) {
    this._super(...arguments);

    let experience = this.modelFor('explore.experience');
    controller.setProperties({
      products: model,
      experienceName: experience.get('name')
    });
  }
});
