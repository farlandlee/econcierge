import Ember from 'ember';
import RouteTitleMixin from 'client/mixins/route-title';

const initialTitle = window.document.title;

const {$, RSVP} = Ember;

export default Ember.Route.extend(RouteTitleMixin, {
  // hijack all server rendered explore links
  init () {
    $('a[href*="/explore"]').on('click', e => {
      e.preventDefault();
      let [, path] = e.target.href.split("/explore");
      this.transitionTo(path);
    });
  },

  model () {
    return this.store.findAll('activity');
  },

  setupController (controller, activities) {
    this._super(...arguments);
    controller.set('activities', activities);
  },

  title (tokens) {
    tokens.push(initialTitle);
    return tokens.join(' | ');
  },

  error ({errors, isAdapterError}, transition) {
    // a product was unpublished.
    // clearing the cart is better than never being able to go to the cart again
    if (isAdapterError && errors.isAny('status', 404)) {
      let destroyAllBookings = this.store.peekAll('booking').map((b) => b.destroyRecord());
      return RSVP.all(destroyAllBookings).then(transition.retry);
    }
  }
});
