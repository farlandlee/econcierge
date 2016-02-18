import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import wait from 'ember-test-helpers/wait';

moduleForComponent('amount-selector', 'Integration | Component | amount selector', {
  integration: true
});

const mockedPrice = {
  amounts: [
    {min_quantity: 1, max_quantity: 2, amount: 100},
    {min_quantity: 3, max_quantity: 4, amount: 75},
    {min_quantity: 5, max_quantity: 10, amount: 50}
  ],
  id: 1
};
test('correct parses amounts', function(assert) {
  this.set('price', mockedPrice);

  // should initialize to the minimum quantity & cost
  let expectedCost = 100;

  this.set('actions', {
    updateCost (_price, cost) {
      assert.equal(cost, expectedCost);
    }
  });

  this.render(hbs`{{amount-selector price=price updateCost=(action "updateCost")}}`);

  let buttons = this.$('.input-group-button');
  let decrementor = buttons.first();
  let incrementor = buttons.last();
  function decrementAndExpect(cost) {
    expectedCost = cost;
    decrementor.click();
    return wait();
  }
  function incrementAndExpect(cost) {
    expectedCost = cost;
    incrementor.click();
    return wait();
  }
  let input = this.$('input');
  function setAndExpect(quantity, cost) {
    expectedCost = cost;
    input.val(quantity);
    return wait();
  }
  return wait()
  .then(() => incrementAndExpect(200)) //2
  .then(() => incrementAndExpect(225)) // 3
  .then(() => decrementAndExpect(200)) // 2
  .then(() => decrementAndExpect(100)) // 1
  .then(() => decrementAndExpect(100)) // still 1
  .then(() => decrementAndExpect(100)) // still 1
  .then(() => incrementAndExpect(200)) // 2
  .then(() => incrementAndExpect(225)) // 3
  .then(() => incrementAndExpect(300)) // 4
  .then(() => incrementAndExpect(250)) // 5
  .then(() => incrementAndExpect(300)) // 6
  .then(() => incrementAndExpect(350)) // 7
  .then(() => incrementAndExpect(400)) // 8
  .then(() => incrementAndExpect(450)) // 9
  .then(() => incrementAndExpect(500)) // 10
  .then(() => incrementAndExpect(500)) // still 10
  .then(() => incrementAndExpect(500)) // still 10
  .then(() => setAndExpect(1, 100))
  .then(() => setAndExpect(5, 250))
  .then(() => setAndExpect(100, 500))
  .then(() => setAndExpect(-1, 100));
});
