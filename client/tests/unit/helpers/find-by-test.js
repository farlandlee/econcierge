import { findBy } from '../../../helpers/find-by';
import { module, test } from 'qunit';

module('Unit | Helper | find by');

// Replace this with your real tests.
test('it works', function(assert) {
  let array = [{foo: 'bar', id: 1}, {foo: 'baz', id: 2}];
  let key = 'foo';
  let value = 'baz';
  let result = findBy([array, key, value]);
  assert.equal(result.id, 2);
});
