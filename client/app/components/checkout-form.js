/* global Stripe */
import Ember from 'ember';
import config from 'client/config/environment';

//@TODO this should eventually be done in an initializer, and we might want
// to make stripe into a service. but for march 1st deadline, tech debt!!!!!11!1
Stripe.setPublishableKey(config.stripePublishableKey);

const {
  computed,
  computed: {notEmpty, and},
  inject
} = Ember;

const devData = {
  email: "fake-email@outpostjh.com",
  name: "Fake Dev",
  phone: "123-456-7890",
  ccName: "Fake Dev",
  ccNumber: "4242424242424242",
  ccMonth: "12",
  ccYear: "20",
  ccCode: "123"
};

export default Ember.Component.extend({
  tagName: 'form',

  cart: null,
  coupon: null,
  ajax: inject.service(),

  email: null,
  name: null,
  phone: null,

  emailNotEmpty: notEmpty('email'),
  nameNotEmpty: notEmpty('name'),
  phoneNotEmpty: notEmpty('phone'),

  ccNumber: null,
  ccName: null,
  ccMonth: null,
  ccYear: null,
  ccCode: null,

  ccNumberNotEmpty: notEmpty('ccNumber'),
  ccNameNotEmpty: notEmpty('ccName'),
  ccMonthNotEmpty: notEmpty('ccMonth'),
  ccYearNotEmpty: notEmpty('ccYear'),
  ccCodeNotEmpty: notEmpty('ccCode'),

  init () {
    this._super(...arguments);
    if (config.environment === 'development') {
      this.setProperties(devData);
    }
  },

  userValid: and('emailNotEmpty', 'nameNotEmpty', 'phoneNotEmpty'),
  cardValid: and('ccNumberNotEmpty', 'ccNameNotEmpty', 'ccMonthNotEmpty', 'ccYearNotEmpty', 'ccCodeNotEmpty'),
  valid: and('cardValid', 'userValid'),

  errorMessage: computed('emailNotEmpty', 'nameNotEmpty', 'phoneNotEmpty',
    'ccNumberNotEmpty', 'ccNameNotEmpty', 'ccMonthNotEmpty', 'ccYearNotEmpty', 'ccCodeNotEmpty',
  {
    // after a property has changed, clear message
    get () {return '';},
    set (_key, value) {return value;}
  }),

  processing: false,
  disableSubmit: computed('processing', 'valid', {
    get () {
      return this.get('processing') || !this.get('valid');
    }
  }),

  submit (event) {
    event.preventDefault();

    let msg = 'Please fill out all fields';

    if (!this.get('cardValid')) {
      this.set('cardErrorMessage', msg);
      return;
    } else {
      this.set('cardErrorMessage', null);
    }

    if (!this.get('userValid')) {
      this.set('contactErrorMessage', msg);
      return;
    } else {
      this.set('contactErrorMessage', null);
    }

    let card = {
      // stripe required fields
      number: this.get('ccNumber'),
      exp_month: this.get('ccMonth'),
      exp_year: this.get('ccYear'),
      // stripe optional fields
      cvc: this.get('ccCode'),
      name: this.get('ccName')
    };

    this.set('processing', true);

    return this._createStripeToken(card)
    .then(
      stripeToken => this._placeOrder(stripeToken),
      ({error}) => this.set('cardErrorMessage', error.message)
    ).finally(() => this.set('processing', false));
  },

  _createStripeToken (card) {
    return new Ember.RSVP.Promise(function (resolve, reject) {
      Stripe.card.createToken(card, (status, response) => {
        if (response.error) {
          return reject(response);
        }
        else {
          return resolve(response);
        }
      });
    });
  },

  _placeOrder ({id}) {
    let user = this.getProperties('email', 'name', 'phone');
    let coupon = this.get('coupon');

    // map bookings so that we have a basic array,
    // rather than a record array (can't stringify record arrays)
    let bookings = this.get('cart').map(b => b);

    let payload = JSON.stringify({
      cart: bookings,
      user: user,
      stripe_token: id,
      coupon: coupon
    });

    return this.get('ajax')
    .post('orders', {data: payload})
    .then(
      this.attrs.onSubmit,
      (error) => this._orderFailure(error)
    );
  },

  _orderFailure ({errors}) {
    if (errors) {
      let cartErrors = [];
      errors.forEach(error => {
        if (error.type === 'ValidationError') {
          this.set('contactErrorMessage', 'Validation errors on contact information. Please check that your email is correct.');
        } else if (error.type === 'CartError') {
          this.get('cart').forEach(i => i.destroyRecord());
          cartErrors.push(error);
        } else {
          // don't know what it is, throw up
          throw error;
        }
      });
      this.set('cartErrors', cartErrors);
    }
  },

  actions: {
    setCoupon (coupon) {
      this.set('coupon', coupon);
    }
  }
});
