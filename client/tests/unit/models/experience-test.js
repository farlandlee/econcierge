import { moduleForModel, test } from 'ember-qunit';

moduleForModel('experience', 'Unit | Model | experience', {
  // Specify the other units that are required for this test.
  needs: ['model:category', 'model:activity']
});

test('it exists', function(assert) {
  let model = this.subject();
  // let store = this.store();
  assert.ok(!!model);
});
