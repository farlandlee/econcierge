import Ember from 'ember';

export default Ember.Mixin.create({
  throwNotFound() {
    return Ember.RSVP.reject({errors: [{errorType: 'NotFoundError'}]});
  },
  actions: {
    error(error, transition) {
      if (error.errors && error.errors[0].errorType === 'NotFoundError') {
        transition.abort();
        return this.transitionTo('error404', transition.intent.url);
      }

      return this._super(...arguments);
    }
  }
});