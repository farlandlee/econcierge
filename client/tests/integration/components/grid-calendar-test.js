import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('grid-calendar', 'Integration | Component | grid calendar', {
  integration: true
});

test('it renders', function(assert) {
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });"

  this.set('date', '2016-02-11');
  this.set('actions', {
    changeDate () {}
  });

  this.render(hbs`{{grid-calendar date=date changeDate=(action 'changeDate')}}`);

  assert.equal(this.$('input.grid-calendar').val(), 'Thu, February 11, 2016');
});
