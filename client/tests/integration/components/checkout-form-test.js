import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('checkout-form', 'Integration | Component | checkout form', {
  integration: true
});

test('it renders', function(assert) {
  this.render(hbs`{{checkout-form}}`);

  assert.equal(this.$('.credit-card legend').text().trim(), 'Credit Card');

  assert.ok(this.$('input[name="ccname"]').length);
  assert.ok(this.$('input[name="ccnumber"]').length);
  assert.ok(this.$('input[name="ccmonth"]').length);
  assert.ok(this.$('input[name="ccyear"]').length);
  assert.ok(this.$('input[name="cccode"]').length);

  assert.equal(this.$('.contact-information legend').text().trim(), 'Contact Information');
  // renders inputs
  assert.ok(this.$('input[name="name"]').length);
  assert.ok(this.$('input[name="email"]').length);
  assert.ok(this.$('input[name="phone"]').length);
  // no errors on render
  assert.notOk(this.$('.checkout-error').length);

  assert.equal(this.$('.coupon legend').text().trim(), 'Got a coupon code? Enter it below.');

  assert.equal(this.$('button[type="submit"]').last().text().trim(), 'Submit Request(s)');

});
