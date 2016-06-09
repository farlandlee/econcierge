/* globals ga */

import Ember from 'ember';
import config from 'client/config/environment';

export default Ember.Mixin.create({
  trackPageView: Ember.on('didTransition', function() {
    let page = config.baseURL.slice(0, -1) + this.get('url');

    ga('send', 'pageview', {
      'page': page,
      'title': page
    });
  })
});
