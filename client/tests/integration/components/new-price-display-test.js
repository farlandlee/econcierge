import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('price-display', 'Integration | Component | price display', {
  integration: true
});

test('it renders the amount of the starting (lowest by min_quantity) amount', function(assert) {
  this.set('price', {
    name: 'Price',
    amounts: [
      {amount: 1200, min_quantity: 2, max_quantity: 3},
      {amount: 1700, min_quantity: 0, max_quantity: 1}
    ]
  });
  this.render(hbs`{{new-price-display price=price}}`);

  assert.equal(this.$('.price').text().trim(), 'from $1700');
});
