import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import moment from 'moment';

moduleForComponent('booking-form', 'Integration | Component | booking form', {
  integration: true
});

test('it renders', function(assert) {
  let defaultPrice = {
    id: 1,
    amounts: [{min_quantity: 0, max_quantity: 0, amount: 100}],
    name: 'The default price'
  };
  this.setProperties({
    date: moment().add(2, 'days').format('YYYY-MM-DD'),
    product: {
      startTimes: [],
      defaultPrice: defaultPrice,
      prices: [defaultPrice]
    },
    actions:  {
      date () {},
      cancel () {},
      submit () {}
    }
  });
  this.render(hbs`{{booking-form
    product=product
    changeDate=(action "date")
    cancel=(action "cancel")
    submit=(action "submit")
  }}`);

  assert.equal(this.$('.booking-form-header').text().trim(), 'Book this experience');
});
