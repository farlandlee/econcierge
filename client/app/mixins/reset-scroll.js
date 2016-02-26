import Ember from 'ember';

export default Ember.Mixin.create({
  activate () {
    this._super(...arguments);
    Ember.$('body, html, .off-canvas-wrapper').animate({scrollTop: 0}, 'fast');
  }
});
