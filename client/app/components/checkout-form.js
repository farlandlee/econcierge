import Ember from 'ember';

const {
  computed,
  computed: {notEmpty, and}
} = Ember;

export default Ember.Component.extend({
  tagName: 'form',

  email: null,
  name: null,
  phone: null,

  emailNotEmpty: notEmpty('email'),
  nameNotEmpty: notEmpty('name'),
  phoneNotEmpty: notEmpty('phone'),
  valid: and('emailNotEmpty', 'nameNotEmpty', 'phoneNotEmpty'),

  showError: computed('emailNotEmpty', 'nameNotEmpty', 'phoneNotEmpty', {
    // after a property has changed, stop showing error
    get () {return false;}, 
    set (_key, value) {return value;}
  }),

  submit (event) {
    event.preventDefault();

    if (this.get('valid')) {
      let properties = this.getProperties('email', 'name', 'phone');
      this.attrs.onSubmit(properties);
    } else {
      this.set('showError', true);
    }
  }
});
