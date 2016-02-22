import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import moment from 'moment';

moduleForComponent('grid-calendar', 'Integration | Component | grid calendar', {
  integration: true
});

test('it renders', function(assert) {
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });"

  let tomorrow = moment().add(1, 'days');

  this.set('date', tomorrow.format('YYYY-MM-DD'));
  this.set('actions', {
    changeDate () {}
  });

  this.render(hbs`{{grid-calendar date=date changeDate=(action 'changeDate')}}`);

  assert.equal(this.$('input.grid-calendar').val(), tomorrow.format('ddd, MMMM D, YYYY'));
});
