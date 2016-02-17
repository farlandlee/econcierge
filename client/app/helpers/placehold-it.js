import Ember from 'ember';

export function placeholdIt(params) {
  let [image, dimensions] = params;
  return image ? image : 'http://placehold.it/' + dimensions;
}

export default Ember.Helper.helper(placeholdIt);
