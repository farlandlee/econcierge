import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('coupon-code-input', 'Integration | Component | coupon code input', {
  integration: true
});

test('it renders', function(assert) {
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });"

  this.render(hbs`{{coupon-code-input}}`);

  assert.equal(this.$('button').text().trim(), 'Check Code');
});
