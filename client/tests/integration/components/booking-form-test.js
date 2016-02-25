import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('booking-form', 'Integration | Component | booking form', {
  integration: true
});

test('it renders', function(assert) {
  this.set('product', {
    startTimes: [],
    prices: []
  });
  this.set('actions', {
    cancel () {},
    submit () {}
  });
  this.render(hbs`{{booking-form product=product cancel=(action "cancel") submit=(action "submit")}}`);

  assert.equal(this.$('h3.text-center').text().trim(), 'Enter Your Trip Details');
});
