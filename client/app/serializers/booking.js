import ApplicationSerializer from 'client/serializers/application';

export default ApplicationSerializer.extend({
  serialize () {
    let serialized = this._super(...arguments);
    // remove non property keys from the object so that
    // there will be no errors saving it into the DB.
    return JSON.parse(JSON.stringify(serialized));
  }
});
