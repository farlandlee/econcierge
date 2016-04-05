import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('filter-selector', 'Integration | Component | filter selector', {
  integration: true
});

const initialize = function initialize (what) {
  what.setProperties({
    clearButtonLabel: "Clear Test",
    options: [
      {label: "label", value: "value"}
    ],
    selectedValues: [],
    actions: {
      selected: function () {},
      clear: function () {}
    }
  });
};

const render = function render (what) {
  what.render(hbs`
    {{filter-selector
      clearButtonLabel=clearButtonLabel options=options
      selectedValues=selectedValues
      labelPath="label" valuePath="value"
      onSelect=(action 'selected')
      clear=(action 'clear')
    }}`
  );
};

test('it renders', function(assert) {
  initialize(this);

  let calledAction = false;
  this.set('actions.selected', function (value) {
    calledAction = true;
    assert.equal(value, "value");
  });

  render(this);

  this.$('button').click();
  assert.ok(calledAction);

  assert.equal(this.$('.filter-option:first-child .filter-label').text().trim(), this.get('clearButtonLabel'));
  assert.equal(this.$('.filter-option:nth-child(2) .filter-label').text().trim(), this.get('options.firstObject.label'));
});

test('it renders checkmarks', function (assert) {
  initialize(this);
  render(this);
  // parses selectedValues correctly
  assert.ok(this.$('.filter-option:first-child .checkmark').length);
  this.set('selectedValues', [this.get('options.firstObject.value')]);
  // still only one thing checked, but...
  assert.ok(this.$('.checkmark').length === 1);
  // it's the first option now
  assert.ok(this.$('.filter-option:nth-child(2) .checkmark').length);
});
