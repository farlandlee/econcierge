import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('checkout-form', 'Integration | Component | checkout form', {
  integration: true
});

test('it renders', function(assert) {
  this.render(hbs`{{checkout-form}}`);

  assert.equal(this.$('legend').first().text().trim(), 'Credit Card');

  assert.ok(this.$('input[name="ccname"]').length);
  assert.ok(this.$('input[name="ccnumber"]').length);
  assert.ok(this.$('input[name="ccmonth"]').length);
  assert.ok(this.$('input[name="ccyear"]').length);
  assert.ok(this.$('input[name="cccode"]').length);

  assert.equal(this.$('legend').last().text().trim(), 'Contact Information');
  // renders inputs
  assert.ok(this.$('input[name="name"]').length);
  assert.ok(this.$('input[name="email"]').length);
  assert.ok(this.$('input[name="phone"]').length);
  // no errors on render
  assert.notOk(this.$('.checkout-error').length);

  assert.equal(this.$('button[type="submit"]').text().trim(), 'Submit Request(s)');

});
