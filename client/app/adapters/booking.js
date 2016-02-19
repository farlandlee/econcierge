import LFAdapter from 'ember-localforage-adapter/adapters/localforage';

export default LFAdapter.extend({
  namespace: 'grid',
  caching: 'all',
  // LFAdapter naively returns an array,
  // wrap it like a RESTAPI would
  findAll() {
    return this._super(...arguments).then(bookings =>{
      return {bookings: bookings};
    });
  }
});
