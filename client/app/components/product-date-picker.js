import Ember from 'ember';
import moment from 'moment';
import {startTimeFilterForDate, format} from 'client/utils/time';

const {computed, computed: {alias}} = Ember;

export default Ember.Component.extend({
  product: null,
  date: null,

  startTimes: alias('product.startTimes'),

  minDate: computed('startTimes.@each.start_date', {
    get () {
      let minDate = this.get('startTimes')
        .sortBy('start_date')
        .get('firstObject.start_date');

      let tomorrow = moment().add(1, 'day');
      minDate = tomorrow.isBefore(minDate) ? minDate : tomorrow;

      return format(minDate);
    }
  }),

  maxDate: computed('startTimes.@each.end_date', {
    get () {
      let maxDate = this.get('startTimes')
        .sortBy('end_date')
        .get('lastObject.end_date');
      return format(maxDate);
    }
  }),

  disable: computed('minDate', 'maxDate', 'startTimes.@each.{monday,tuesday,wednesday,thursday,friday,saturday,sunday}', {
    get () {
      let startTimes = this.get('startTimes');
      let date = moment(this.get('minDate'));
      let maxDate = moment(this.get('maxDate'));

      let disabledDates = [];
      let disabledRangeStart = null;

      do {
        let isAvailable = this._isAvailable(date, startTimes);

        if (isAvailable) {
          // is this the end of a disabled range?
          if (disabledRangeStart) {
            // flatpickr disabled ranges are inclusive,
            // so it is disabled up to the previous date
            let disabledRangeEnd = format(date.clone().add(-1, 'day'));
            disabledDates.push({
              from: disabledRangeStart,
              to: disabledRangeEnd
            });
            // reset the range
            disabledRangeStart = null;
          }
        } else if (!disabledRangeStart) {
            disabledRangeStart = format(date);
        }
      } while (date.add(1, 'day').isSameOrBefore(maxDate));

      return disabledDates;
    }
  }),

  _isAvailable (date, startTimes) {
    let filter = startTimeFilterForDate(date);
    let availableStartTimes = startTimes.filter(filter);
    return availableStartTimes.length > 0;
  }
});
