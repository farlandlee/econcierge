import LFAdapter from 'ember-localforage-adapter/adapters/localforage';
import NotFoundMixin from 'client/mixins/not-found';

export default LFAdapter.extend(NotFoundMixin, {
  namespace: 'grid',
  // must be none or we get some weird indexDB error when we try to save more
  // than one item in a session.
  // i can only do so much debugging. i know this fixes it, but not why
  caching: 'none',
  // LFAdapter naively returns an array,
  // wrap it like a RESTAPI would
  findAll () {
    return this._super(...arguments).then(bookings =>{
      return {bookings: bookings};
    });
  },
  // seriously, these guys did nothing right. should we just fork this adapter?
  // override to a) return a rest response and b) throw a proper not found error
  findRecord (store, type, id) {
    return this._getNamespaceData(type).then(namespaceData => {
      var booking = namespaceData.records[id];

      if (!booking) {
        return this.throwNotFound();
      }

      return {booking: booking};
    });
  }
});
