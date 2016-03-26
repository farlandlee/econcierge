import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('product-icons', 'Integration | Component | product icons', {
  integration: true
});

test('it renders pickup', function(assert) {
  this.set('product', {
    pickup: true
  });
  this.render(hbs`{{new-product-icons product=product}}`);

  assert.equal(this.$('.location').text().trim(), 'Pick Up');

  this.set('product.pickup', false);
  assert.equal(this.$('.location').text().trim(), 'Meet At Location');
});

test('it renders duration', function(assert) {
  this.set('product', {});
  this.render(hbs`{{new-product-icons product=product}}`);

  this.set('product.duration', 300);
  assert.equal(this.$('.duration').text().trim(), '5 Hours');

  this.set('product.duration', 121);
  assert.equal(this.$('.duration').text().trim(), '2.02 Hours');

  this.set('product.duration', 45);
  assert.equal(this.$('.duration').text().trim(), '45 Minutes');
});

test('it renders rating', function(assert) {
  this.set('product', {
    vendor: {}
  });
  this.render(hbs`{{new-product-icons product=product}}`);

  this.set('product.vendor.tripadvisorRating', null);
  assert.equal(this.$('.vendor-rating').text().trim(), 'This vendor is not yet rated');

  this.set('product.vendor.tripadvisorRating', 0);
  assert.equal(this.$('.vendor-rating').text().trim(), 'This vendor is not yet rated');

  this.set('product.vendor.tripadvisorRating', 5);
  assert.equal(this.$('.vendor-rating').text().trim(), 'Vendor Rating');
});
