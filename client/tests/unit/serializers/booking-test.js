import { moduleForModel, test } from 'ember-qunit';

moduleForModel('booking', 'Unit | Serializer | booking', {
  // Specify the other units that are required for this test.
  needs: [
    'serializer:booking',
    'serializer:application',
    'model:booking',
    'model:product',
    'model:activity',
    
    'model:category'
  ]
});

// Replace this with your real tests.
test('it serializes records', function(assert) {
  let record = this.subject();

  let serializedRecord = record.serialize();

  assert.ok(serializedRecord);
});
