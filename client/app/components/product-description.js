import Ember from 'ember';

const {computed} = Ember;

export default Ember.Component.extend({
  tagName: '',
  product: null,

  description: computed('product.description', {
    get () {
      let description = this.get('product.description');
      let limit = 160;
      let output = description;
      if (output !== undefined && output !== null && output.length > limit){
        output = output.substr(0, limit - 3).trimRight() + "...";
      }
      return output;
    }
  })
});
