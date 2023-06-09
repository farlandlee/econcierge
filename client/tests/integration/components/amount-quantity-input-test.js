import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import wait from 'ember-test-helpers/wait';

moduleForComponent('amount-quantity-input', 'Integration | Component | amount quantity input', {
  integration: true
});

const getLabel = function (what) {
  return what.$('.amount-label').text().trim().replace(/\s+/g, ' ');
};

const setupLabelTest = function (what) {
    what.setProperties({
      price: {
        people_count: 1,
        name: 'my price',
        id: 1,
        amounts: [
          {id: 1, min_quantity: 1, max_quantity: 2, amount: 100},
          {id: 2, min_quantity: 3, max_quantity: 0, amount: 50}
        ]
      },
      quantities: [
        {id: 1, quantity: 0}
      ],
      actions: {
        doNothing () {}
      }
    });
};

const renderLabelTest = function (what) {
  what.render(hbs`
    {{amount-quantity-input showAmountLabel=true price=price quantities=quantities onChange=(action "doNothing")}}
  `);
};

test('Quantity label for single person', function(assert) {
  setupLabelTest(this);

  renderLabelTest(this);

  assert.equal(getLabel(this), '$100 per person');
});

test('Quantity label for multiple people', function(assert) {
  setupLabelTest(this);
  this.set('price.people_count', 2);

  renderLabelTest(this);

  assert.equal(getLabel(this), '$100 per 2 people');
});

test('Quantity label for higher quantity', function(assert) {
  setupLabelTest(this);
  this.set('quantities', [{id: this.get('price.id'), quantity: 5}]);

  renderLabelTest(this);

  assert.equal(getLabel(this), '$50 per person');
});

test('Quantity label for higher quantity and multiple people', function(assert) {
  setupLabelTest(this);
  this.set('price.people_count', 2);
  this.set('quantities', [{id: this.get('price.id'), quantity: 5}]);

  renderLabelTest(this);

  assert.equal(getLabel(this), '$50 per 2 people');
});

test('correctly parses amounts', function(assert) {
  this.set('price', {
    name: 'my price',
    id: 1,
    amounts: [
      {id: 1, min_quantity: 1, max_quantity: 2, amount: 100},
      {id: 2, min_quantity: 3, max_quantity: 4, amount: 75},
      {id: 3, min_quantity: 5, max_quantity: 10, amount: 50}
    ]
  });
  this.set('quantities', [
    {id: 1, quantity: 0}
  ]);

  // should initialize to the minimum quantity & cost
  let expectedAmountId = 1;
  let expectedQuantity = 1;
  let runNumber = 0;
  this.set('actions', {
    test (amount, quantity) {
      assert.equal(quantity, expectedQuantity, 'unexpected quantity');
      assert.equal(amount.id, expectedAmountId, 'unexpected amount' + runNumber++);
    }
  });

  this.render(hbs`
    {{amount-quantity-input price=price quantities=quantities onChange=(action "test")}}
  `);

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
  .then(() =>   setAndExpect(-1,  1, 1))
  .then(() => incrementAndExpect( 2, 1));
});
