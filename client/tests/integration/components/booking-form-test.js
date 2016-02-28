import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('booking-form', 'Integration | Component | booking form', {
  integration: true
});

test('it renders', function(assert) {
  let defaultPrice = {
    id: 1,
    amounts: [{min_quantity: 0, max_quantity: 0, amount: 100}],
    name: 'The default price'
  };
  this.setProperties({
    product: {
      startTimes: [],
      defaultPrice: defaultPrice,
      prices: [defaultPrice]
    },
    actions:  {
      cancel () {},
      submit () {}
    }
  });
  this.render(hbs`{{booking-form product=product cancel=(action "cancel") submit=(action "submit")}}`);

  assert.equal(this.$('h3.text-center').text().trim(), 'Enter Your Trip Details');
});
