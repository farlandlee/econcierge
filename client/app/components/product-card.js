import Ember from 'ember';
import {pluralize} from 'ember-inflector';

function inflect(count, word) {
  if (count > 1) {
    word = pluralize(word);
  }
  return count + ' ' + word;
}

const {computed} = Ember;

export default Ember.Component.extend({
  classNames: 'product',
  product: null,
  duration: computed('product.duration', {
    get () {
      let duration = this.get('product.duration');
      let hours = Math.floor(duration / 60);
      let minutes = duration % 60;
      let output = '';
      if (hours) {
        output += inflect(hours, "Hour");
      }
      if (minutes) {
        if (output) {
          output += ' ';
        }
        output += inflect(minutes, "Minute");
      }
      return output;
    }
  })
});
