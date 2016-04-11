import { selectedAmenityOptionCount } from '../../../helpers/selected-amenity-option-count';
import { module, test } from 'qunit';

module('Unit | Helper | selected amenity option count');

test('it works', function(assert) {
  let result = selectedAmenityOptionCount([[{id: 42}], [42]]);
  assert.equal(result, '(1)');

  result = selectedAmenityOptionCount([[{id: 42}], [41]]);
  assert.equal(result, '');
});
