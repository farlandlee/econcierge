import RESTAdapter from 'ember-data/adapters/rest';

export default RESTAdapter.extend({
  namespace: '/web_api',
  coalesceFindRequests: true
});
