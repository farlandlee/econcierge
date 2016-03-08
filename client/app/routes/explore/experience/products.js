import Ember from 'ember';

export default Ember.Route.extend({
  model () {
    let experience = this.modelFor('explore.experience');
    let {date} = this.modelFor('explore');

    return this.store.query('product', {
      experience_id: experience.id,
      date: date
    });
  },

  setupController (controller, products) {
    this._super(...arguments);
    let {date} = this.modelFor('explore');
    let experienceName = this.modelFor('explore.experience').get('name');

    controller.setProperties({products, date, experienceName});
  }
});
