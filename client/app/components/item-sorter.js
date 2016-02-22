import Ember from 'ember';

export default Ember.Component.extend({
  tagName: '',
  items: null,
  by: ['name:asc'],
  sortedItems: Ember.computed.sort('items', 'by')
});
