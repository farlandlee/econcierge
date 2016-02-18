import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('time-selector', 'Integration | Component | time selector', {
  integration: true
});

test('it renders', function(assert) {
  this.set('times', [
    {starts_at_time: "8:00"}
  ]);
  this.render(hbs`{{time-selector times=times}}`);

  assert.equal(this.$('label').text().trim(), 'Time');
  assert.equal(this.$('option').text().trim(), '8:00');
});
