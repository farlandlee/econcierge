/* globals Foundation */
import Ember from 'ember';

export default Ember.Component.extend({
  tagName: 'span',
  tipText: null,
  positionClass: 'bottom',

  classNames: ['has-tip', 'right'],

  didInsertElement () {
    let el = this.$();
    let options = this.getProperties(
      'tipText', 'positionClass'
    );
    let tooltip = new Foundation.Tooltip(el, options);
    this.setProperties({tooltip});
  }
});
