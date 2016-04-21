import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import Ember from 'ember';

moduleForComponent('product-description', 'Integration | Component | product description', {
  integration: true
});

test('it renders short description', function(assert) {
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });"
  this.set('product', Ember.Object.create({short_description: "<p>Buy FishCo's A superb Fly Fishing experience.</p>"}));

  this.render(hbs`{{product-description product=product}}`);

  assert.equal(this.$().text().trim().replace( /\s+/g, ' ' ), "Buy FishCo's A superb Fly Fishing experience. Read More");

});

test('it renders long description', function(assert) {
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });"
  this.set('product', {
    short_description: "<p>Buy FishCo's A superb Fly Fishing experience. Donec sodales sagittis magna. Nulla sit amet est. Cras non dolor. Pellentesque libero tortor, tincidunt et, tincidunt eget, semper nec, quam.</p>"
  });

  this.render(hbs`{{product-description product=product}}`);

  assert.equal(this.$().text().trim().replace( /\s+/g, ' ' ), "Buy FishCo's A superb Fly Fishing experience. Donec sodales sagittis magna. Nulla sit amet est. Cras non dolor. Pellentesque libero tortor, tincidunt et, tincidunt eget, semper nec, quam. Read More");

});
