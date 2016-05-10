import Ember from 'ember';
import {pluralize} from 'ember-inflector';

const {computed} = Ember;

function inflect(count, word) {
  if (count > 1) {
    word = pluralize(word);
  }
  return count + ' ' + word;
}

export default Ember.Component.extend({
  tagName: '',
  product: null,
  shrink: false,

  duration: computed('product.duration', {
    get () {
      let duration = this.get('product.duration');
      let hours = +(duration / 60).toFixed(2);

      let output = '';
      if(hours < 1) {
        output += inflect(duration, "Minute");
      }
      else  {
        output += inflect(hours, "Hour");
      }
      return output;
    }
  }),

  rating: computed('product.vendor.tripadvisorRating', {
    get () {
      let rating = this.get('product.vendor.tripadvisorRating');
      let fullStars = Math.floor(rating);
      let halfStars = rating % 1;
      let output = '';
      if (fullStars) {
        for ( let i = 0; i < fullStars; i++) {
          output += '<i class="fa fa-star gold"></i>';
        }
      }
      if (halfStars) {
        output += '<i class="fa fa-star-half gold"></i>';
      }
      return Ember.String.htmlSafe(output);
    }
  })
});
