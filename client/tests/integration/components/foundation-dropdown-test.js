import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('foundation-dropdown', 'Integration | Component | foundation dropdown', {
  integration: true
});

test('it renders', function(assert) {
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });"

  this.render(hbs`{{foundation-dropdown}}`);

  assert.equal(this.$().text().trim(), '');

  // Template block usage:"
  this.render(hbs`
    {{#foundation-dropdown}}
      template block text
    {{/foundation-dropdown}}
  `);

  assert.equal(this.$().text().trim(), 'template block text');
});
