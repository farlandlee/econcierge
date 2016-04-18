/* globals flatpickr */
import Ember from 'ember';
import moment from 'moment';

const {computed} = Ember;

export default Ember.Component.extend({
  classNames: 'grid-calendar',
  // Default settings
  dateFormat: 'D, F j, Y',
  defaultDate: null,
  minDate: computed({
    get () { return moment().add(1, 'days').toDate(); }
  }),
  maxDate: null,
  placeholder: 'Pick a date',
  flatpickr: null,
  inline: true,

  didRender () {
    this._super(...arguments);
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

    this.set('flatpickr', flatpickr(selector, options));
    // Flatpickr immediately triggers onchange when it's initialized,
    // so don't add the onchange listener until after render.
    Ember.run.next(this, () => {
      this.get('flatpickr').set('onChange', Ember.run.bind(this, this._dateDidChange));
    });
  },

  _dateDidChange (newDate) {
    if (newDate) {
      let defaultDate = this.get('defaultDate');
      if (!moment(newDate).isSame(defaultDate)) {
        return this.attrs.changeDate(...arguments);
      }
    }
  },

  actions: {
    open () {
      this.get('flatpickr').open();
    },

    clear () {
      this.attrs.changeDate(null);
    }
  }
});
