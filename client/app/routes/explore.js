import Ember from 'ember';
import NotFoundMixin from 'client/mixins/not-found';
import ResetScrollMixin from 'client/mixins/reset-scroll';
import RouteTitleMixin from 'client/mixins/route-title';
import {format, parseDate} from 'client/utils/time';

export default Ember.Route.extend(NotFoundMixin, ResetScrollMixin, RouteTitleMixin, {
  queryParams: {
    date: {
      refreshModel: true
    }
  },

  titleToken ({activity, category}) {
    return [category.get('name'), activity.get('name')];
  },

  model (params) {
    let {activity_slug, category_slug, date} = params;

    if (!parseDate(date).isValid()) {
      date = undefined;
    }

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

      let experiencesQuery = this.store.query('experience', {
        activity_id: activity.get('id'),
        category_id: category.get('id')
      });

      return Ember.RSVP.hash({
        activity: activity,
        category: category,
        experiences: experiencesQuery,
        date: date
      });
    });
  },

  setupController (controller, model) {
    this._super(...arguments);
    controller.setProperties(model);
  },

  actions: {
    changeDate (date) {
      date = format(date);
      this.transitionTo({queryParams: {date: date}});
    }
  }
});
