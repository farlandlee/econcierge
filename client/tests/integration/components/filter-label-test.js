import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('filter-label', 'Integration | Component | filter removing label', {
  integration: true
});

test('can set label directly', function(assert) {
  this.render(hbs`{{filter-label label="Hello World"}}`);

  assert.equal(this.$().text().trim(), 'Hello World');
});

test('its clever too', function(assert) {
  this.setProperties({
    value: 'foo',
    filters: [{value: 'foo', text: 'bar'}]
  });
  this.render(hbs`
    {{filter-label
      value=value filters=filters
      valuePath="value"
      labelPath="text"
    }}`);

  assert.equal(this.$().text().trim(), 'bar');
});
