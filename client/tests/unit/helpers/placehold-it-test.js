import { placeholdIt } from '../../../helpers/placehold-it';
import { module, test } from 'qunit';

module('Unit | Helper | placehold it');

test('gets real image source', function(assert) {
  let image = "http://image.com/image.jpg";
  let result = placeholdIt([image, "150x150"]);
  assert.equal(result, image);
});

test('gets placehold.it src', function(assert) {
  let result = placeholdIt([null, "150x150"]);
  assert.equal(result, "http://placehold.it/150x150?text=Image+Coming+Soon");
});
