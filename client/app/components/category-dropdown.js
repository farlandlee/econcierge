import Ember from 'ember';

const {computed} = Ember;

export default Ember.Component.extend({
  tagName: 'ul',

  activity: null,
  category: null,
  sortedCategories: computed('category', 'activity.categories.@each.name', {
    get () {
      let sortedArray = this.get('activity').get('categories').sortBy('name');
      let cat = this.get('category');
      sortedArray.removeObject(cat);
      sortedArray.unshiftObject(cat);
      return sortedArray;
    }
  })
});
