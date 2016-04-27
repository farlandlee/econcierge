import Ember from 'ember';
import {sortFieldToString} from 'client/controllers/explore';

const options = Object.keys(sortFieldToString);

export default Ember.Component.extend({
  sort: null,
  options
});
