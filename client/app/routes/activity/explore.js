import Ember from 'ember';
import NotFoundMixin from 'client/mixins/not-found';
import ResetScrollMixin from 'client/mixins/reset-scroll';
import RouteTitleMixin from 'client/mixins/route-title';
import {parseDate} from 'client/utils/time';

const {$, RSVP} = Ember;

export default Ember.Route.extend(NotFoundMixin, ResetScrollMixin, RouteTitleMixin, {
  activate () {
    $('body').addClass('no-footer');
  },

  deactivate () {
    $('body').removeClass('no-footer');
  },

  model ({category_slug, date}) {
    if (date && !parseDate(date).isValid()) {
      return this.replaceWith({queryParams: {date: undefined}});
    }

    let products;
    let queryFilter = {
      activity_id: this.modelFor('activity').get('id')
    };

    if (!category_slug) {
      products = this.store.query('product', queryFilter);
    } else {
      products = this.store.findAll('category').then(categories => {
        let category = categories.findBy('slug', category_slug);
        if (!category) {
          return this.throwNotFound();
        }
        queryFilter.category_id = category.get('id');
        return this.store.query('product', queryFilter);
      });
    }

    return products;
  },

  afterModel (products) {
    return RSVP.hash({
      vendors: RSVP.all(products.mapBy('vendor')),
      categories: RSVP.all(products.mapBy('categories'))
    });
  },

  serialize (category) {
    if (!category) {
      return {category_slug: ''};
    } else {
      return {category_slug: category.get('slug')};
    }
  },

  setupController (controller, products) {
    this._super(...arguments);
    controller.set('products', products);
    controller.set('activity', this.modelFor('activity'));
    controller.set('activities', this.store.peekAll('activity'));
  }
});
