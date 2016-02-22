import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('time-selector', 'Integration | Component | time selector', {
  integration: true
});

test('it renders', function(assert) {
  this.set('times', [
    {starts_at_time: "08:00:00"},
    {starts_at_time: "11:00:00"},
    {starts_at_time: "18:00:00"}
  ]);
  this.render(hbs`{{time-selector times=times}}`);

  assert.equal(this.$('label').text().trim(), 'Time');
  // renders placeholder
  assert.equal(this.$('option:nth-child(1)').text().trim(), 'Select a time...');
  // for some reason the nested sorting doesn't work in tests.
  // see item-sorter-test for proof of sorting working...
  assert.equal(this.$('option:nth-child(2)').text().trim(), '8:00 am');
  assert.equal(this.$('option:nth-child(3)').text().trim(), '11:00 am');
  assert.equal(this.$('option:nth-child(4)').text().trim(), '6:00 pm');
});
