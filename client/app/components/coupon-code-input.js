import Ember from 'ember';

const {computed, inject} = Ember;

export default Ember.Component.extend({
  classNames: ["input-group"],

  code: null,
  coupon: null,

  ajax: inject.service(),

  disabled: computed('code', {
    get () {
      let code = this.get('code');
      return !code || code.length < 5;
    }
  }),

  actions: {
    submitCode () {
      let code = this.get('code');
      return this.get('ajax')
      .put('coupons', {data: {code}})
      .then(({coupon}) => {
        this.set('code', coupon.code);
        return this.attrs.couponVerified(coupon);
      });
    }
  }
});
