import Ember from 'ember';
import NotFoundMixin from 'client/mixins/not-found';
import ResetScrollMixin from 'client/mixins/reset-scroll';
import RouteTitleMixin from 'client/mixins/route-title';
import {parseDate} from 'client/utils/time';

const {$, RSVP} = Ember;

export default Ember.Route.extend(NotFoundMixin, ResetScrollMixin, RouteTitleMixin, {
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
  },

  activate () {
    // manually track whether transitions into this route are from other routes or from interior,
    // so that we can display the correct loading page
    this.set('entering', true);
    $('body').addClass('no-footer');
  },

  deactivate () {
    $('body').removeClass('no-footer');
  },

  actions: {
    didTransition () {
      if (this.get('entering')) {
        this.set('entering', false);
      }
    },

    loading (transition) {
      // if this is a model swap within the route, do custom loading
      if (!this.get('entering') && this.controller) {
        this.controller.set('loading', true);
        transition.finally(() => this.controller.set('loading', false));
        return false;
      }
      // bubble up for a normal loading substate if we aren't doing our custom load behaviour
      return true;
    }
  }
});
