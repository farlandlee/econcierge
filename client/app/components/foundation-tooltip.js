/* globals Foundation */
import Ember from 'ember';

export default Ember.Component.extend({

  tooltipText: null,

  didInsertElement () {
    let el = this.$();
    let text = this.get('tooltipText');
    let options = {
      tipText: text,
      positionClass: 'bottom'
    };
    new Foundation.Tooltip(el, options);
  },

});
