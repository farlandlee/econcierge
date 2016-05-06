import Ember from 'ember';

export function findBy([array, key, value]/*, hash*/) {
  return array.findBy(key, value);
}

export default Ember.Helper.helper(findBy);
