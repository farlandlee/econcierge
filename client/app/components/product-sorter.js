import Ember from 'ember';

export default Ember.Component.extend({
  options: null,

  actions: {
    select (value) {
      return this.attrs.onSelect(value);
    }
  }
});
