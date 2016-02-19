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
      this.transitionTo('explore.experience.products');
    },
    book (product, priceCosts, time) {
      let {date} = this.modelFor('explore');

      time = {
        time: time.starts_at_time,
        id: time.id
      };

      let quantities = product.get('prices').map(price => {
        let cost = priceCosts[price.id];
        let quantity = cost ? cost.quantity : 0;
        return {
          id: price.id,
          quantity: quantity
        };
      });

      let booking = this.store.createRecord('booking', {
        product: product,
        date: date,
        startTime: time,
        quantities: quantities
      });

      return booking.save().then(() => {
        this.transitionTo('explore.experience.products');
      });
    }
  }
});
