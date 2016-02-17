/* globals Foundation */
import Ember from 'ember';

export default Ember.Component.extend({
  classNameBindings: ['size'],
  classNames: ['reveal'],
  size: 'large',

  didInsertElement() {
    let el = this.$();
    let reveal = new Foundation.Reveal(el, {});
    reveal.open();
    el.on('closed.zf.reveal', () => {
      this.attrs.onClose();
    });
    this.set('reveal', reveal);
  }
});
