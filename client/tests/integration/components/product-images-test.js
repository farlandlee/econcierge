import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('product-images', 'Integration | Component | product images', {
  integration: true
});

test('it renders', function(assert) {
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });"
  this.set('images', []);

  this.render(hbs`{{product-images images=images}}`);

  assert.equal(this.$().text().trim(), 'photo gallery');

});
