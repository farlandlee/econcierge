import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import moment from 'moment';

moduleForComponent('time-selector', 'Integration | Component | time selector', {
  integration: true
});

const timeFactory = function timeFactory(startsAt, startDateOffset, endDateOffset) {
  return {
    monday: true, tuesday: true,
    wednesday: true, thursday: true, friday: true,
    saturday: true, sunday: true,
    starts_at_time: startsAt,
    start_date: moment().add(startDateOffset, 'days').format('YYYY-MM-DD'),
    end_date: moment().add(endDateOffset, 'days').format('YYYY-MM-DD')
  };
};

test('it filters start times by date and dotw', function(assert) {
  let [today, tomorrow, yesterday, asatte] = [0, 1, -1, 2];

  let neverActuallyHappens = timeFactory("00:00:00", yesterday, today);
  neverActuallyHappens.monday = false;
  neverActuallyHappens.tuesday = false;
  neverActuallyHappens.wednesday = false;
  neverActuallyHappens.thursday = false;
  neverActuallyHappens.friday = false;
  neverActuallyHappens.saturday = false;
  neverActuallyHappens.sunday = false;

  this.set('today', moment().format('YYYY-MM-DD'));
  this.set('times', [
    timeFactory("23:59:59", tomorrow, asatte),
    timeFactory("08:00:00", yesterday, today),
    timeFactory("11:00:00", today, tomorrow),
    timeFactory("18:00:00", yesterday, tomorrow),
    neverActuallyHappens
  ]);
  this.render(hbs`{{time-selector date=today times=times}}`);

  assert.equal(this.$('label').text().trim(), 'Time');
  assert.equal(this.$('option').length, 4);
  assert.equal(this.$('option:nth-child(1)').text().trim(), 'Select');
  assert.equal(this.$('option:nth-child(2)').text().trim(), '8:00 am');
  assert.equal(this.$('option:nth-child(3)').text().trim(), '11:00 am');
  assert.equal(this.$('option:nth-child(4)').text().trim(), '6:00 pm');
});
