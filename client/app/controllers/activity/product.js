import Ember from 'ember';

const {
  inject,
  computed
} = Ember;

export default Ember.Controller.extend({
  explore: inject.controller('activity.explore'),
  // essentially a one way binding on explore.date
  date: computed('explore.date', {
    get () {
      return this.get('explore.date');
    },
    set (_k, value) {
      return value;
    }
  })
});
