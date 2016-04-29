import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('grid-accordion-body', 'Integration | Component | grid accordion body', {
  integration: true
});

test('it renders', function(assert) {
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });"

  this.render(hbs`{{grid-accordion-body}}`);

  assert.equal(this.$().text().trim(), '');

  // Template block usage:"
  this.render(hbs`
    {{#grid-accordion-body}}
      template block text
    {{/grid-accordion-body}}
  `);

  assert.equal(this.$().text().trim(), 'template block text');
});
