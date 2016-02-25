import Ember from 'ember';

export function placeholdIt(params) {
  let [image, dimensions] = params;
  return image ? image : `http://placehold.it/${dimensions}?text=Image+Coming+Soon`;
}

export default Ember.Helper.helper(placeholdIt);
