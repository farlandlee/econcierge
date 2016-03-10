import Ember from 'ember';
import momentCP from 'ember-moment/computeds/moment';
import {startTimeFilterForDate} from 'client/utils/time';

const {computed} = Ember;

export default Ember.Component.extend({
  date: null,
  times: null,

  momentDate: momentCP('date'),
  timesForDate: computed('momentDate', 'times.@each.{start_date,end_date}', {
    get () {
      let times = this.get('times');
      let date = this.get('momentDate');
      let filter = startTimeFilterForDate(date);
      return times.filter(filter).sortBy('starts_at_time');
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
