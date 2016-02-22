import Ember from 'ember';

export default Ember.Component.extend({
  times: null,

  actions: {
    change (event) {
      let times = this.get('times');
      let id = parseInt(event.target.value);
      let time = id ? times.findBy('id', id) : null;
      this.attrs.onChange(time);
    }
  }
});
