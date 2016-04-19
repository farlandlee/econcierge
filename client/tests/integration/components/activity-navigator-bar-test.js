import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('activity-navigator-bar', 'Integration | Component | activity navigator bar', {
  integration: true
});

test('it renders', function(assert) {
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });"

  this.render(hbs`{{activity-navigator-bar}}`);

  assert.equal(this.$().text().trim(), '');

  // Template block usage:"
  this.render(hbs`
    {{#activity-navigator-bar}}
      template block text
    {{/activity-navigator-bar}}
  `);

  assert.equal(this.$().text().trim(), 'template block text');
});
