import Ember from 'ember';
import {truncate} from 'client/helpers/truncate';

const {computed} = Ember;  //this acts as an alias to the compute method in ember

export default Ember.Component.extend({
  tagName: '',
  product: null,

  description: computed('product.description', {
    get () {
      let description = this.get('product.description');
      
      if (!Ember.isEmpty(description)) {
        let limit = 160;
        let output = description.replace(/(<([^>]+)>)/ig,"");

        if (output.length > limit){
          output = truncate([output], {limit: limit});
        }

        return output;
      }

      return description;
    }
  })
});
