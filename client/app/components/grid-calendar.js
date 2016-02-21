import Ember from 'ember';
import moment from 'moment';

const {computed} = Ember;

export default Ember.Component.extend({
  minDate: moment().add(1, 'days'),

  formattedMinDate: computed('minDate', {
    get () {
      return this.get('minDate').format('YYYY-MM-DD');
    }
  })
});
