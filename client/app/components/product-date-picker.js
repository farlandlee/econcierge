import Ember from 'ember';
import moment from 'moment';
import {startTimeAvailableForDate, format} from 'client/utils/time';
import {flatten} from 'client/utils/fn';

const {
  computed,
  observer
} = Ember;

export default Ember.Component.extend({
  date: null,

  // It's possible that the date handed in to this component
  // is invalid for the products set. If that's the case, immediately call
  // changeDate to set the value to null.
  _clearInvalidDate: observer('date', 'startTimes', 'minDate', 'maxDate', function () {
    let date = this.get('date');
    if (date && this.get('_products').length) {
      let {minDate, maxDate, startTimes} = this.getProperties('minDate', 'maxDate', 'startTimes');
      if (date < minDate || date > maxDate || !this._isAvailable(date, startTimes)) {
        this.attrs.changeDate(null);
      }
    }
  }),

  _products: [],

  product: computed({
    get () {
      return this.get('_products.firstObject');
    },
    set (_key, value) {
      this.set('_products', [value]);
      return value;
    }
  }),

  products: computed({
    get () {
      return this._products;
    },
    set (_key, value) {
      this.set('_products', value);
      return value;
    }
  }),

  startTimes: computed('_products.[]', {
    get () {
      return this.get('_products')
        .mapBy('startTimes')
        .reduce(flatten, []);
    }
  }),

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

  disable: computed('minDate', 'maxDate', 'startTimes.[]', {
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
    let availableOnDate = startTimeAvailableForDate(date);
    return startTimes.any(availableOnDate);
  }
});
