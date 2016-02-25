import Ember from 'ember';
import NotFoundMixin from 'client/mixins/not-found';

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
    let {date} = this.modelFor('explore');
    controller.set('product', product);
    // used in product time selection
    controller.set('date', date);
  },

  actions: {
    goToProducts () {
      this.transitionTo('explore.experience.products');
    },

    book (product, {quantities, date, time}) {
      let {category, activity} = this.modelFor('explore');
      let experience = this.modelFor('explore.experience');
      time = {
        time: time.starts_at_time,
        id: time.id
      };

      let booking = this.store.createRecord('booking', {
        activity: activity,
        experience: experience,
        category: category,
        product: product,
        date: date,
        startTime: time,
        quantities: quantities
      });

      return booking.save().then(booking => {
        this.transitionTo('booked', booking.id);
      }, error => {
        //@TODO...
        console.error(error);
        throw error;
      });
    }
  }
});
