import Ember from 'ember';
import {sortFieldToString} from 'client/controllers/explore/products';

const options = Object.keys(sortFieldToString);

export default Ember.Component.extend({
  sort: null,
  options
});
