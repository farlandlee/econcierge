import Ember from 'ember';

const {
  computed
} = Ember;

export default Ember.Component.extend({
  classNames: 'product new-card',
  product: null,

  addSlideshow: computed('product.images.[]', {
    get () {
      return this.get('product.images').length > 1;
    }
  }),

  addSingleImage: computed('product.images.[]', {
    get () {
      return this.get('product.images').length === 1;
    }
  })
});
