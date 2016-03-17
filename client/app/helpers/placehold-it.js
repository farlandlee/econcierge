import Ember from 'ember';

export function placeholdIt(params) {
  let [image, dimensions] = params;
  return image ? image : `https://placehold.it/${dimensions}?text=Image+Coming+Soon`;
}

export default Ember.Helper.helper(placeholdIt);
