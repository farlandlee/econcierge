import Ember from 'ember';

const {computed} = Ember;

export default Ember.Component.extend({
  tagName: '',
  
  activity: null,
  category: null,

  sortedCategories: computed('category', 'activity.categories.@each.name', {
    get () {
      let sortedCategories = this.get('activity.categories').sortBy('name');
      // until we fix up jquery, the selected cat has to be the first in the list
      let cat = this.get('category');
      sortedCategories.removeObject(cat);
      sortedCategories.unshiftObject(cat);
      return sortedCategories;
    }
  })
});
