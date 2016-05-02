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

    if(this.get('useLightGallery')) {
      this.$('.lightgallery').lightGallery({
        selector: ".orbit-slide",
        download: false
      });
    }
    // prevent clicking next and previous from opening link if images are linked
    // see product cards to booking modal for example
    this.$('.orbit-next, .orbit-previous').click(function(e) {
      e.stopPropagation();
    });
  }
});
