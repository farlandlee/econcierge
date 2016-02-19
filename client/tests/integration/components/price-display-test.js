import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('price-display', 'Integration | Component | price display', {
  integration: true
});

test('it renders price name', function(assert) {
  this.set('price', {
    name: 'Some price'
  });
  this.render(hbs`{{price-display price=price}}`);
  assert.equal(this.$('.price-label').text().trim(), 'Some price');
});

test('it renders multiple people text based on people_count', function(assert) {
  this.set('price', {
    people_count: 3
  });
  this.render(hbs`{{price-display price=price}}`);

  assert.equal(this.$('.price-unit').text().trim(), 'per 3 people');
  this.set('price.people_count', 1);
  assert.equal(this.$('.price-unit').text().trim(), 'per person');
});

test('it renders the amount of the starting (lowest by min_quantity) amount', function(assert) {
  this.set('price', {
    name: 'Price',
    amounts: [
      {amount: 1200, min_quantity: 2, max_quantity: 3},
      {amount: 1700, min_quantity: 0, max_quantity: 1}
    ]
  });
  this.render(hbs`{{price-display price=price}}`);

  assert.equal(this.$('.price').text().trim(), '$1700');
});
