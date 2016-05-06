import Ember from 'ember';
import NotFoundMixin from 'client/mixins/not-found';
import ResetScrollMixin from 'client/mixins/reset-scroll';
import RouteTitleMixin from 'client/mixins/route-title';
import {parseDate} from 'client/utils/time';

const {$, RSVP} = Ember;

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

  model ({activity_slug, category_slug, date}) {
    if (date && !parseDate(date).isValid()) {
      return this.replaceWith({queryParams: {date: undefined}});
    }

    let activities = this.store.peekAll('activity');
    let activity = activities.findBy('slug', activity_slug);
    if (!activity) {
      console.error("Activity not found");
      return this.throwNotFound();
    }

    let categories = this.store.peekAll('category');
    if (!categories.findBy('slug', category_slug)) {
      categories = this.store.query('category', {
        activity_id: activity.get('id')
      });
    }

    return RSVP.resolve(categories).then(categories => {
      let category = categories.findBy('slug', category_slug);
      if (!category) {
        console.error("Category not found");
        return this.throwNotFound();
      }

      let products = this.store.query('product', {
        category_id: category.get('id')
      });

      return RSVP.hash({
        activity,
        category,
        date,
        products
      });
    });
  },

  afterModel ({products}) {
    return RSVP.all(products.mapBy('vendor'));
  },

  setupController (controller, model) {
    this._super(...arguments);
    controller.setProperties(model);
    controller.set('activities', this.store.peekAll('activity'));
    controller.set('categories', this.store.peekAll('category'));
  }
});
