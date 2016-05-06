import Ember from 'ember';
import ProductCard from './new-product-card';

const {
  computed
} = Ember;

export default ProductCard.extend({
  classNames: 'product photo-card',

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
