import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('price-display', 'Integration | Component | price display', {
  integration: true
});

test('it renders multiple people helper text', function(assert) {
  this.set('price', {
    name: 'Price',
    people_count: 3
  });
  this.render(hbs`{{price-display price=price}}`);

  assert.equal(this.$('.price-label').text().trim(), 'Price');
  assert.equal(this.$('.help-text').text().trim(), '(per 3 people)');
});

test('it renders single person helper text', function(assert) {
  this.set('price', {
    people_count: 1
  });
  this.render(hbs`{{price-display price=price}}`);

  assert.equal(this.$('.help-text').text().trim(), '(per person)');
});
