import DS from 'ember-data';
import Ember from 'ember';

const {computed} = Ember;

export default DS.Model.extend({
  name: DS.attr(),
  description: DS.attr(),
  slug: DS.attr(),
  activity: DS.belongsTo('activity'),
  image: DS.attr(),
  displayName: computed('name', 'activity.name', {
    get () {
      let activity = this.get('activity');
      if (!activity.get('isLoaded')) {
        throw `
        Lazy loading is evil.
        Make sure you preloaded this category's activity if you need its displayName.
        `;
      }

      let activityName = activity.get('name');
      let name = this.get('name');

      if (activityName === name) {
        return name;
      }
      return `${activityName} - ${name}`;
    }
  })
});
