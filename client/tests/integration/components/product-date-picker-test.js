import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import moment from 'moment';

moduleForComponent('product-date-picker', 'Integration | Component | product date picker', {
  integration: true
});

test('it renders', function(assert) {
  this.setProperties({
    product: {
      startTimes: [
      ]
    },
    date: moment().add(2, 'days').format('YYYY-MM-DD'),
    actions: {
      changeDate () {}
    }
  });

  this.render(hbs`{{product-date-picker product=product date=date changeDate=(action "changeDate")}}`);

  assert.ok(this.$('input[type="hidden"]')[0]);
});
