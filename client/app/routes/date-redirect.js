import Ember from 'ember';
import NotFoundMixin from 'client/mixins/not-found';

export default Ember.Route.extend(NotFoundMixin, {
  model ({activity_slug, category_slug}) {
    let activities = this.store.peekAll('activity');
    let activity = activities.findBy('slug', activity_slug);

    if (!activity) {
      console.error("Activity not found");
      return this.throwNotFound();
    }

    let categoriesQuery = this.store.query('category', {
      activity_id: activity.get('id')
    });

    return Ember.RSVP.hash({
      activity: activity,
      categories: categoriesQuery
    }).then(({activity, categories}) => {
      let category = categories.findBy('slug', category_slug);

      if (!category) {
        console.error("Category not found");
        return this.throwNotFound();
      }

      return {category, activity};
    });
  },

  redirect ({activity, category}) {
    let activitySlug = activity.get('slug');
    let categorySlug = category.get('slug');
    let dateApiUrl = `/web_api/date/${activitySlug}/${categorySlug}`;
    return Ember.$.getJSON(dateApiUrl).then(response => {
      let date = response.date;
      return this.transitionTo('explore', activitySlug, categorySlug, date);
    });
  },

  serialize ({activity, category}) {
    return {
      activity_slug: activity.get('slug'),
      category_slug: category.get('slug')
    };
  }
});
