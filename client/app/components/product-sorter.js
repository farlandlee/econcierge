import Ember from 'ember';
import {sortFieldToString} from 'client/controllers/explore/experience/products';

const options = Object.keys(sortFieldToString);

export default Ember.Component.extend({
  sort: null,
  options
});
