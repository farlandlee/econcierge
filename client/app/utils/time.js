import Ember from 'ember';
import moment from 'moment';

export const toMoment = function toMoment (date) {
  if (!date) {
    Ember.Logger.warn('TimeUtils#toMoment expected value. Defaulting to now..');
  }
  return moment.isMoment(date) ? date : moment(date);
};

export const parseDate = function parseDate (date) {
  // the "true" means it has to match this format exactly
  return moment(date, 'YYYY-MM-DD', true);
};

export const format = function format (date) {
  return toMoment(date).format('YYYY-MM-DD');
};

export const dayOfTheWeek = function dayOfTheWeek(date) {
  switch (toMoment(date).day()) {
    case 0:
      return "sunday";
    case 1:
      return "monday";
    case 2:
      return "tuesday";
    case 3:
      return "wednesday";
    case 4:
      return "thursday";
    case 5:
      return "friday";
    case 6:
      return "saturday";
  }
};

export const startTimeFilterForDate = function startTimeFilterForDate (date) {
  return function startTimeMatchesDate (startTime) {
    let {start_date, end_date} = startTime;
    if (date.isSameOrAfter(start_date) && date.isSameOrBefore(end_date)) {
      let dotw = dayOfTheWeek(date);
      return startTime[dotw];
    }
  };
};
