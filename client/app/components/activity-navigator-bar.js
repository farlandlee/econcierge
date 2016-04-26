import Ember from 'ember';

const { $ } = Ember;

export default Ember.Component.extend({
  tagName: 'nav',

  classNames: 'activity-nav',

  didInsertElement() {
    this._super(...arguments);

    let parent = $('.explore-right');
    let scrollDist = $(window).height() * 0.35;

    parent.scroll(function(){
      if(parent.scrollTop() > scrollDist) {
        parent.addClass('scrolled');
      }
      else {
        parent.removeClass('scrolled');
      }
    });

    // handle window resize / turning device
    $(window).resize(function(){
      let windowWidth = $( window ).width();
      if(windowWidth > 639) {
        $('.explore-left').removeClass('open');
      }
    });

  },

  actions: {
    openFilters () {
      $('.explore-left').addClass('open');
    }
  }
});
