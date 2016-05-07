import Ember from 'ember';
import Quantity, {amountForQuantity} from 'client/models/quantity';

const {Component, computed, $} = Ember;

export default Component.extend({
  classNames: 'booking-form',
  product: null,
  date: null,

  total: 0,
  quantities: null,
  time: null,

  canProceed: computed('total', 'time', 'quantities.@each.quantity', 'product.prices.[]', {
    get () {
      // has a total, time, and date
      let {total, time, date} = this.getProperties('total', 'time', 'date');
      if (!total || !date || !time) {
        return false;
      }
      // All prices have valid quantities
      let quantities = this.get('quantities');
      let priceHasValidQuantity = (price) => {
        let {amounts, id} = price;
        let {quantity} = quantities.findBy('id', id);
        return !!amountForQuantity(amounts, quantity);
      };

      return this.get('product.prices').every(priceHasValidQuantity);
    }
  }),

  init () {
    this._super(...arguments);
    let quantities = this.get('product.prices').map(p => {
      return Quantity.create({
        id: p.id,
        quantity: 0,
        cost: 0
      });
    });
    this.set('quantities', quantities);
  },

  didInsertElement () {
    this._super(...arguments);
    let el = this.$();
    let contentContainer = $('.content-container');
    let windowWidth = $(window).width();
    let contentContainerHeight = contentContainer.outerHeight();
    let elHeight = el.outerHeight();

    //if sidebar is taller than content increase height to match;
    if(elHeight > contentContainerHeight && windowWidth > 1024 ) {
      contentContainer.css('padding-bottom',elHeight - contentContainerHeight);
    }

    $(window).resize(function(){
      windowWidth = $(window).width();
      contentContainerHeight = contentContainer.outerHeight();
      elHeight = el.outerHeight();
      if(elHeight > contentContainerHeight && windowWidth > 1024 ) {
        contentContainer.css('padding-bottom',elHeight - contentContainerHeight);
      }
      else if(windowWidth < 1025){
        contentContainer.removeAttr('style');
      }
    });

  },

  actions: {
    updateQuantity (price, amount, quantity) {
      let cost = amount.amount * quantity;
      let quantities = this.get('quantities');
      let priceQuantity = quantities.findBy('id', price.id);
      priceQuantity.setProperties({cost, quantity});

      let total = quantities.mapBy('cost')
        .reduce((total, cost) => total + cost, 0);

      this.set('total', total);
      this.set('quantities', quantities);
    },

    updateDate (date) {
      this.set('date', date);
    },

    updateTime (time) {
      this.set('time', time);
    },

    submit () {
      if (this.get('canProceed')) {
        let properties = this.getProperties('quantities', 'time', 'date');
        this.attrs.submit(properties);
      }
    }
  }
});
