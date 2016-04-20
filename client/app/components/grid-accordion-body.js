import Ember from 'ember';

export default Ember.Component.extend({
  isExpanded: true,
  click () {
    return this.attrs.onClick();
  }
});
