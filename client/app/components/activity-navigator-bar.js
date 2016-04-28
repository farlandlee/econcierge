import Ember from 'ember';

const { $ } = Ember;

export default Ember.Component.extend({
  tagName: 'nav',

  classNames: 'activity-nav',

  didInsertElement() {
    this._super(...arguments);
    let $window = $(window);

    let parent = $('.explore-right');

    parent.scroll(function () {
      // .35 is based on the 40vh that the image takes up
      if (parent.scrollTop() > $window.height() * 0.35) {
        parent.addClass('scrolled');
      } else {
        parent.removeClass('scrolled');
      }
    });

    // handle window resize / turning device
    $window.resize(function () {
      if ($window.width() > 639) {
        $('.explore-left').removeClass('open');
      }
    });
  }
});
