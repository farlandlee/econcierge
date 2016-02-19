import Ember from 'ember';

const {computed} = Ember;

export default Ember.Component.extend({
  times: null,

  time: computed('times.[]', {
    get () {
      return this.get('times.firstObject');
    }
  }),

  actions: {
    change (event) {
      let id = parseInt(event.target.value);
      let times = this.get('times');
      let time = times.findBy('id', id);
      this.attrs.onChange(time);
    }
  }
});
