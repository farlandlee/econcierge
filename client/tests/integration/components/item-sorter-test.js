import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('item-sorter', 'Integration | Component | item sorter', {
  integration: true
});

test('it sorts by name asending by default', function(assert) {
  this.set('items', [
    {name: 'a'},
    {name: 'd'},
    {name: 'c'},
    {name: 'b'}
  ]);

  this.render(hbs`
    <div>
    {{#item-sorter items=items as |item|}}
      <span>{{item.name}}</span>
    {{/item-sorter}}
    </div>
  `);

  assert.equal(this.$('span:nth-child(1)').text().trim(), 'a');
  assert.equal(this.$('span:nth-child(2)').text().trim(), 'b');
  assert.equal(this.$('span:nth-child(3)').text().trim(), 'c');
  assert.equal(this.$('span:nth-child(4)').text().trim(), 'd');
});

test('sorting is parameterized by `by` field.', function(assert) {
  this.set('items', [
    {foo: 'a'},
    {foo: 'd'},
    {foo: 'c'},
    {foo: 'b'}
  ]);

  this.set('sorting', ['foo:desc']);

  this.render(hbs`
    <div>
    {{#item-sorter items=items by=sorting as |item|}}
      <span>{{item.foo}}</span>
    {{/item-sorter}}
    </div>
  `);

  assert.equal(this.$('span:nth-child(1)').text().trim(), 'd');
  assert.equal(this.$('span:nth-child(2)').text().trim(), 'c');
  assert.equal(this.$('span:nth-child(3)').text().trim(), 'b');
  assert.equal(this.$('span:nth-child(4)').text().trim(), 'a');
});
