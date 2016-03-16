import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('chevron-icon', 'Integration | Component | chevron icon', {
  integration: true
});

test('it renders with default direction', function(assert) {
  this.render(hbs`{{chevron-icon}}`);

  assert.ok(this.$('i').hasClass('fa-chevron-down'));
});

test('it renders with given direction', function(assert) {
  this.render(hbs`{{chevron-icon direction="up"}}`);

  assert.ok(this.$('i').hasClass('fa-chevron-up'));
});
