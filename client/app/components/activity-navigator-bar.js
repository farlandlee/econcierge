import Ember from 'ember';

const { $ } = Ember;

export default Ember.Component.extend({
  tagName: 'nav',

  classNames: 'activity-nav',

  didInsertElement() {
    this._super(...arguments);

    let parent = $('.explore-right');

    parent.scroll(function(){
      if(parent.scrollTop() > 0) {
        parent.addClass('scrolled');
      }
      else {
        parent.removeClass('scrolled');
      }
    });
  }
});
