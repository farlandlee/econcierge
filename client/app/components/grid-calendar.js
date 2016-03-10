/* globals flatpickr */
import Ember from 'ember';
import moment from 'moment';

const {computed} = Ember;

export default Ember.Component.extend({
  // Default settings
  dateFormat: 'D, F j, Y',
  defaultDate: null,
  minDate: computed({
    get () { return moment().add(1, 'days').toDate(); }
  }),
  maxDate: null,
  placeholder: 'Pick a date',
  flatpickr: null,
  inline: false,

  didRender () {
    let selector = `#${this.elementId} .datepicker`;
    let options = this.getProperties(
      'dateFormat',
      'defaultDate',
      'disable',
      'minDate',
      'maxDate',
      'value',
      'placeholder',
      'inline'
    );
    options.onChange = Ember.run.bind(this, function (date) {
      // flatpickr immediately runs its onChange on initialization
      // make sure that we don't notify for the same value we initialized with
      if (date) {
        let defaultDate = this.get('defaultDate');
        if (!moment(date).isSame(defaultDate)) {
          return this.attrs.changeDate(...arguments);
        }
      }
    });

    this.set('flatpickr', flatpickr(selector, options));
  },

  actions: {
    open () {
      this.get('flatpickr').open();
    }
  }
});
