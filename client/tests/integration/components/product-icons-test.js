import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('product-icons', 'Integration | Component | product icons', {
  integration: true
});

test('it renders pickup', function(assert) {
  this.set('product', {
    pickup: true
  });
  this.render(hbs`{{product-icons product=product}}`);

  assert.equal(this.$('.location').text().trim(), 'Pick Up');

  this.set('product.pickup', false);
  assert.equal(this.$('.location').text().trim(), 'Meet At Location');
});

test('it renders duration', function(assert) {
  this.set('product', {});
  this.render(hbs`{{product-icons product=product}}`);

  this.set('product.duration', 300);
  assert.equal(this.$('.duration').text().trim(), '5 Hours');

  this.set('product.duration', 121);
  assert.equal(this.$('.duration').text().trim(), '2 Hours 1 Minute');

  this.set('product.duration', 45);
  assert.equal(this.$('.duration').text().trim(), '45 Minutes');
});
