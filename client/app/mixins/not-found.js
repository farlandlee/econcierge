import Ember from 'ember';

export default Ember.Mixin.create({
  throwNotFound() {
    return Ember.RSVP.reject({errors: [{errorType: 'NotFoundError'}]});
  },
  actions: {
    error(error, transition) {
      if (error.errors && error.errors[0].errorType === 'NotFoundError') {
        transition.abort();
        // drop the leading slash so we don't do `explore//<url>`
        let attemptedUrl = transition.intent.url.substring(1);
        return this.transitionTo('error404', attemptedUrl);
      }

      let superReturn = this._super(...arguments);
      if (superReturn === undefined) {
        //bubble if there was no super
        return true;
      }
      return superReturn;
    }
  }
});
