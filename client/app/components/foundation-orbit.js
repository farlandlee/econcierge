/* globals Foundation */
import Ember from 'ember';

export default Ember.Component.extend({
  classNames: [ 'orbit', 'row', 'expanded' ],
  tagName: 'section',

  didInsertElement () {
    this._super(...arguments);
    let el = this.$();
    let options = {
      autoPlay: false,
      infiniteWrap: true,
    };
    new Foundation.Orbit(el, options);

    this.$('.lightgallery').lightGallery({
      selector: ".orbit-slide",
      download: false
    });
  }
});
