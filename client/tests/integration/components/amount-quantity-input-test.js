import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import wait from 'ember-test-helpers/wait';

moduleForComponent('amount-quantity-input', 'Integration | Component | amount quantity input', {
  integration: true
});

test('correctly parses amounts', function(assert) {
  this.set('amounts', [
    {id: 1, min_quantity: 1, max_quantity: 2, amount: 100},
    {id: 2, min_quantity: 3, max_quantity: 4, amount: 75},
    {id: 3, min_quantity: 5, max_quantity: 10, amount: 50}
  ]);

  // should initialize to the minimum quantity & cost
  let expectedAmountId = 100;
  let expectedQuantity = 1;
  let runNumber = 0;
  this.set('actions', {
    test (amount, quantity) {
      assert.equal(quantity, expectedQuantity, 'unexpected quantity');
      assert.equal(amount.id, expectedAmountId, 'unexpected amount' + runNumber++);
    }
  });

  this.render(hbs`{{amount-quantity-input amounts=amounts onChange=(action "test")}}`);

  let buttons = this.$('.input-group-button');
  let decrementor = buttons.first();
  let incrementor = buttons.last();
  function decrementAndExpect(quantity, amountId) {
    expectedQuantity = quantity;
    expectedAmountId = amountId;
    decrementor.click();
    return wait();
  }
  function incrementAndExpect(quantity, amountId) {
    expectedQuantity = quantity;
    expectedAmountId = amountId;
    incrementor.click();
    return wait();
  }
  let input = this.$('input');
  function setAndExpect(setTo, quantity, amountId) {
    expectedQuantity = quantity;
    expectedAmountId = amountId;
    input.val(setTo);
    return wait();
  }
  return wait()
  .then(() => incrementAndExpect( 2, 1))
  .then(() => incrementAndExpect( 3, 2))
  .then(() => decrementAndExpect( 2, 1))
  .then(() => decrementAndExpect( 1, 1))
  .then(() => decrementAndExpect( 1, 1))
  .then(() =>   setAndExpect(12, 10, 3))
  .then(() =>   setAndExpect(9,   9, 3))
  .then(() =>   setAndExpect(-1,  1, 1));
});
