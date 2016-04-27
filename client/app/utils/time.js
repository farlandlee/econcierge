import Ember from 'ember';
import moment from 'moment';

export const toMoment = (date) => {
  if (!date) {
    Ember.Logger.warn('TimeUtils#toMoment expected value. Defaulting to now..');
  }
  return moment.isMoment(date) ? date : moment(date);
};

export const parseDate = (date) => {
  // the "true" means it has to match this format exactly
  return moment(date, 'YYYY-MM-DD', true);
};

export const format = (date) => {
  return toMoment(date).format('YYYY-MM-DD');
};

export const formatTime = (time) => {
  // 00:00:00 -> 12:00AM
  return moment(time, 'HH:mm:ss', true).format('h:mmA');
};

export const dayOfTheWeek = (date) => {
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

export const startTimeAvailableForDate = function startTimeAvailableForDate (date) {
  date = toMoment(date);
  return function startTimeMatchesDate (startTime) {
    let {start_date, end_date} = startTime;
    if (date.isSameOrAfter(start_date) && date.isSameOrBefore(end_date)) {
      let dotw = dayOfTheWeek(date);
      return startTime[dotw];
    }
  };
};
