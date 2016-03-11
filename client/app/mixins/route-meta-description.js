import Ember from 'ember';

const $description = Ember.$('meta[name="description"]');

export default Ember.Mixin.create({
  description: null,

  actions: {
    didTransition () {
      this._super(...arguments);

      let description = this.get('description');
      if (typeof description === 'function') {
        description = this.description(this.currentModel);
      }

      $description.attr('content', description);

      return true;
    }
  }
});
