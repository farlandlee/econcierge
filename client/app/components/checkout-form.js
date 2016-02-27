/* global Stripe */
import Ember from 'ember';
import config from 'client/config/environment';

//@TODO this should eventually be done in an initializer, and we might want
// to make stripe into a service. but for march 1st deadline, tech debt!!!!!11!1
Stripe.setPublishableKey(config.stripePublishableKey);

const {
  computed,
  computed: {notEmpty, and}
} = Ember;

export default Ember.Component.extend({
  tagName: 'form',

  cart: null,

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

    return new Ember.RSVP.Promise(function (resolve, reject) {
      Stripe.card.createToken(card, (status, response) => {
        if (response.error) {
          return reject(response);
        }
        else {
          return resolve(response);
        }
      });
    }).then(({id}) => {
      let user = this.getProperties('email', 'name', 'phone');

      // map bookings so that we have a basic array,
      // rather than a record array (can't stringify record arrays)
      let bookings = this.get('cart').map(b => b);
      let payload = JSON.stringify({
        cart: bookings,
        user: user,
        stripe_token: id
      });

      return this.placeOrder(payload);
    }, ({error}) => {
      return this.set('cardErrorMessage', error.message);
    });
  },

  placeOrder (payload) {
    return Ember.$.ajax('/web_api/orders', {
      method: 'POST',
      data: payload,
      contentType: 'application/json',
    }).then(() => {
      return this.attrs.onSubmit();
    }, ({responseJSON}) => {
      //TODO: Better error handling and display
      if (responseJSON.errors) {
        this.set('contactErrorMessage', 'Validation errors on contact information. Please check that your email is correct.');
      }

      if (responseJSON.cart_errors) {
        this.get('cart').forEach(i => i.destroyRecord());
        this.set('cartErrors', responseJSON.cart_errors);
      }

      return;
    });
  }
});
