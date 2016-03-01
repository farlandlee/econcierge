import { truncate } from '../../../helpers/truncate';
import { module, test } from 'qunit';

module('Unit | Helper | truncate');

const longString = ["Buy FishCo's A superb Fly Fishing experience. Donec sodales sagittis magna. Nulla sit amet est. Cras non dolor. Pellentesque libero tortor, tincidunt et, tincidunt eget, semper nec, quam."];
const shortString = ["Buy FishCo's A superb Fly Fishing experience. Donec sodales sagittis magna. Nulla sit amet est. Cras non dolor. Pellentesque libero tortor, tincidunt et, tincidunt eget"];
// Replace this with your real tests.
test('it works', function(assert) {
  let result = truncate(longString,{ limit: 180 });
  assert.equal(result, "Buy FishCo's A superb Fly Fishing experience. Donec sodales sagittis magna. Nulla sit amet est. Cras non dolor. Pellentesque libero tortor, tincidunt et, tincidunt eget, semper...");
});

test('it works with null text', function(assert){
  let result = truncate([],{ limit: 180 });
  assert.equal(result, "");
});

test('it works with undefined text', function(assert){
  let result = truncate([undefined],{ limit: 180 });
  assert.equal(result, "");
});

test('it works with shorter string than limit', function(assert) {
  let result = truncate(shortString,{ limit: 180 });
  assert.equal(result, "Buy FishCo's A superb Fly Fishing experience. Donec sodales sagittis magna. Nulla sit amet est. Cras non dolor. Pellentesque libero tortor, tincidunt et, tincidunt eget");
});

test('it works with no limit', function(assert) {
  let result = truncate(shortString);
  assert.equal(result, "Buy FishCo's A superb Fly F...");
});

test('it works with no limit in defined namedArgs', function(assert){
  let result = truncate(shortString,{ foo: 180 });
  assert.equal(result, "Buy FishCo's A superb Fly F...");
});
