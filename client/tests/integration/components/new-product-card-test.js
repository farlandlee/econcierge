import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import Ember from 'ember';

moduleForComponent('product-card', 'Integration | Component | product card', {
  integration: true
});

test('it renders the product card', function(assert) {
  this.set('product', Ember.Object.create());
  this.render(hbs`{{new-product-card product=product}}`);

  this.set('product.duration', 137);
  assert.equal(this.$('.duration').text(), '2.28 Hours');

  this.set('product.duration', 120);
  assert.equal(this.$('.duration').text(), '2 Hours');

  this.set('product.duration', 45);
  assert.equal(this.$('.duration').text(), '45 Minutes');

  this.set('product.duration', 61);
  assert.equal(this.$('.duration').text(), '1.02 Hours');
});
