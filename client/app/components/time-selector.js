import Ember from 'ember';
import momentCP from 'ember-moment/computeds/moment';

const {computed} = Ember;

const dayOfTheWeek = function dayOfTheWeek(momentDate) {
  switch (momentDate.day()) {
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

export default Ember.Component.extend({
  date: null,
  times: null,

  momentDate: momentCP('date'),
  timesForDate: computed('momentDate', 'times.@each.{start_date,end_date}', {
    get () {
      let times = this.get('times');
      let date = this.get('momentDate');
      return times.filter(time => {
        let {start_date, end_date} = time;
        if (date.isSameOrAfter(start_date) && date.isSameOrBefore(end_date)) {
          let dotw = dayOfTheWeek(date);
          return time[dotw];
        }
      }).sortBy('starts_at_time');
    }
  }),

  actions: {
    change (event) {
      let times = this.get('times');
      let id = parseInt(event.target.value);
      let time = id ? times.findBy('id', id) : null;
      this.attrs.onChange(time);
    }
  }
});
