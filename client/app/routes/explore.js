import Ember from 'ember';
import NotFoundMixin from 'client/mixins/not-found';
import ResetScrollMixin from 'client/mixins/reset-scroll';
import RouteTitleMixin from 'client/mixins/route-title';

const { $ } = Ember;

export default Ember.Route.extend(NotFoundMixin, ResetScrollMixin, RouteTitleMixin, {
  titleToken ({activity, category}) {
    return [category.get('name'), activity.get('name')];
  },

  activate () {
    $('body').addClass('no-footer');
  },

  deactivate () {
    $('body').removeClass('no-footer');
  },

  model (params) {
    let {activity_slug, category_slug} = params;

    let activities = this.store.peekAll('activity');
    let activity = activities.findBy('slug', activity_slug);

    if (!activity) {
      console.error("Activity not found");
      return this.throwNotFound();
    }
    // we're loading all categories for this activity
    // because we need them in the template anyways
    return this.store.query('category', {
      activity_id: activity.get('id')
    }).then(categories => {
      let category = categories.findBy('slug', category_slug);

      if (!category) {
        console.error("Category not found");
        return this.throwNotFound();
      }

      return Ember.RSVP.hash({
        activity, category
      });
    });
  },

  setupController (controller, model) {
    this._super(...arguments);
    controller.setProperties(model);
    controller.set('activities', this.store.peekAll('activity'));
  }
});
