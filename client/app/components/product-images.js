import Ember from 'ember';

const {computed} = Ember;

export default Ember.Component.extend({

  firstImage: computed('images.[]', {
    get () {
      return this.get('images').get('firstObject');
    }
  }),

  nextTwoImages: computed('images.[]', {
    get () {
      return this.get('images').slice(1, 3);
    }
  }),

  remainingImages: computed('images.[]', {
    get () {
      return this.get('images').slice(3,100);
    }
  }),

  didInsertElement () {
    this._super(...arguments);

    this.$('.photo-gallery').lightGallery({
      selector: ".lightgallery-item",
      download: false
    });
  }
});
