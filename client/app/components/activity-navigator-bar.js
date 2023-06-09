import Ember from 'ember';

const {
  $
} = Ember;

export default Ember.Component.extend({
  tagName: 'nav',
  classNames: 'activity-nav',

  activity: null,

  didInsertElement() {
    this._super(...arguments);

    let $window = $(window);

    let windowHeight = $window.height();

    if(!this.get('activity.useProductPhotoCard')) {
      let parent = $('.explore-right');

      $window.scroll(function () {
        // .35 is based on the 40vh that the image takes up
        // if .products is not taller than the window, then the flickering header issue occurs
        if ($window.scrollTop() > windowHeight * 0.35 && $('.products').outerHeight() > windowHeight) {
          parent.addClass('scrolled');
        } else {
          parent.removeClass('scrolled');
        }
      });
    }

    // handle window resize / turning device
    $window.resize(function () {
      windowHeight = $window.height();
      if ($window.width() > 639) {
        $('.explore-left').removeClass('open');
        $('body').css('overflow','auto');
      }
    });

    // eliminate scrolling body when scrolling explore-left
    $('.explore-left').on('mouseover', function(){
      $('body').css('overflow','hidden');
    }).on('mouseout', function(){
      $('body').css('overflow','auto');
    });
  }
});
