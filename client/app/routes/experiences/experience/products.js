import Ember from 'ember';

export default Ember.Route.extend({
  model () {
    let experience = this.modelFor('experiences.experience');
    let date = this.modelFor('experiences').date;
    return this.store.query('product', {
      experience_id: experience.id,
      date: date
    });
  },

  setupController (controller, model) {
    this._super(...arguments);

    let experience = this.modelFor('experiences.experience');
    controller.setProperties({
      products: model,
      experienceName: experience.get('name')
    });
  }
});
