import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('better-product-images', 'Integration | Component | better product images', {
  integration: true
});

test('it renders', function(assert) {
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });"

  this.render(hbs`{{better-product-images}}`);

  assert.equal(this.$().text().trim(), '');
});

test('it renders with images', function(assert) {
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });"
  this.set('images',['image.jpg','image2.jpg']);
  this.set('images','image.jpg');

  this.render(hbs`{{better-product-images images=images image=image}}`);

  assert.equal(this.$().text().trim(), 'Click for more images');
});
