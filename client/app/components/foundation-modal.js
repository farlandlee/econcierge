/* globals Foundation */
import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['reveal','booking-modal'],

  didInsertElement () {
    let el = this.$();
    let reveal = new Foundation.Reveal(el, {});
    reveal.open();
    el.on('closed.zf.reveal', () => {
      this._close();
    });
    this.set('reveal', reveal);
  },

  willDestroyElement () {
    this.$().off('closed.zf.reveal');
    this.get('reveal').close();
  },

  _close () {
    this.get('reveal').close();
    return this.attrs.onClose();
  },

  actions: {
    close () {
      return this._close();
    }
  }
});
