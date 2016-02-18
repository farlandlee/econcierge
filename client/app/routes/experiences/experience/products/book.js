import Ember from 'ember';
import NotFoundMixin from 'client/mixins/not-found-mixin';

export default Ember.Route.extend(NotFoundMixin, {
  model (params) {
    let {product_id} = params;
    let product = this.store.peekRecord('product', product_id);
    if (!product) {
      return this.throwNotFound();
    }
    return product;
  },

  setupController (controller, product) {
    this._super(...arguments);
    controller.set('product', product);
  },

  actions: {
    goToProducts () {
      this.transitionTo('experiences.experience.products');
    },
    book () {

    }
  }
});
