import Ember from 'ember';

export default Ember.Component.extend({
  time: Ember.computed('times.[]', function () {
    return this.get('times.firstObject');
  })
});
