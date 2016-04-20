import Ember from 'ember';

export default Ember.Component.extend({
  isExpanded: true,
  actions: {
    toggleExpanded () {
      this.toggleProperty('isExpanded');
    }
  }
});
