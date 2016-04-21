import Ember from 'ember';

const {computed} = Ember;  //this acts as an alias to the compute method in ember

export default Ember.Component.extend({
  tagName: '',
  product: null,

  short_description: computed('product.short_description', {
    get () {
      return Ember.String.htmlSafe(this.get('product.short_description'));
    }
  })
});
