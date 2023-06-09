import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('product-photo-card', 'Integration | Component | product photo card', {
  integration: true
});

test('it renders', function(assert) {
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });"
  this.set('product', {
    image: {
      medium: 'woo',
      alt: 'alt!'
    },
    name: 'Product Name'
  });
  this.render(hbs`{{product-photo-card product=product category=category}}`);

  assert.equal(this.$('img').attr('alt'), 'alt!');
  assert.equal(this.$('.product-title').text(), 'Product Name');
});
