import DS from 'ember-data';
import Ember from 'ember';

const {computed} = Ember;

export default DS.Model.extend({
  description: DS.attr(),
  short_description: DS.attr(),
  name: DS.attr(),
  pickup: DS.attr('boolean'),
  duration: DS.attr('number'),
  defaultPrice: DS.attr(),

  activity: DS.belongsTo('activity'),
  vendor: DS.belongsTo('vendor'),
  categories: DS.hasMany('category'),

  meetingLocation: DS.attr(),
  prices: DS.attr(),
  startTimes: DS.attr(),
  // list of integer ids, see activity.js
  amenityOptions: DS.attr(),

  // images
  defaultImage: DS.attr(),
  images: DS.attr(),
  image: computed('defaultImage', 'activity.image', {
    get () {
      return this.get('defaultImage') || this.get('activity.image');
    }
  }),

  minDefaultPrice: computed('defaultPrice.amounts.@each.min_quantity', {
    get() {
      let quantitySort = this.get('defaultPrice').amounts.sortBy('min_quantity');
      return quantitySort.objectAt(0).amount;
    }
  })
});
