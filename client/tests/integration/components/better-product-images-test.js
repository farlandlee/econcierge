import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('better-product-images', 'Integration | Component | better product images', {
  integration: true
});

test('it has "click for more text" with multiple images', function(assert) {
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });"
  this.set('images',[
    {full: 'full1.jpg', thumb: 'thumb1.jpg'},
    {full: 'full2.jpg', thumb: 'thumb2.jpg'}
  ]);
  this.set('image',{full: 'full.jpg', thumb: 'thumb.jpg'});

  this.render(hbs`{{better-product-images images=images image=image}}`);

  assert.equal(this.$().text().trim(), 'Click for more images');
});
test('it doesn\'t have "click for more text" with single image', function(assert) {
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });"
  this.set('images',[
    {full: 'full1.jpg', thumb: 'thumb1.jpg'}
  ]);
  this.set('image',{full: 'full.jpg', thumb: 'thumb.jpg'});

  this.render(hbs`{{better-product-images images=images image=image}}`);

  assert.equal(this.$().text().trim(), '');
});
