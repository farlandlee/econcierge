import Ember from 'ember';

export function selectedAmenityOptionCount([amenityOptions, selectedOptions]/*, hash*/) {
  let selectedCount = amenityOptions.mapBy('id')
    .filter(o => selectedOptions.contains(o))
    .length;

  if (selectedCount !== 0) {
    return `(${selectedCount})`;
  } else {
    return '';
  }
}

export default Ember.Helper.helper(selectedAmenityOptionCount);
