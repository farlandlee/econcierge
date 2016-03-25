import AjaxService from 'ember-ajax/services/ajax';

export default AjaxService.extend({
  namespace: '/web_api',
  post (_, options) {
    options['contentType'] = 'application/json';
    return this._super(...arguments);
  }
});
