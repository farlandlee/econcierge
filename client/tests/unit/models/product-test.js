import { moduleForModel, test } from 'ember-qunit';

moduleForModel('product', 'Unit | Model | product', {
  // Specify the other units that are required for this test.
  needs: ['model:vendor', 'model:activity', 'model:category']
});

test('it finds and rounds display price', function(assert) {
  let model = this.subject({
    defaultPrice: {
      amounts: [
        {min_quantity: 2},
        {min_quantity: 0, amount: 1.99},
        {min_quantity: 1}
      ]
    }
  });
  // let store = this.store();
  assert.equal(model.get('displayPrice'), 2);
});
