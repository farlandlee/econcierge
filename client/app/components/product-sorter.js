import Ember from 'ember';

export const sortFieldToString = {
  "Price" : ["minDefaultPrice:asc"],
  "Rating" : ["vendor.tripadvisorRating:desc"],
  "Trip Name" : ["name:asc"],
  "Trip Duration" : ["duration:asc"]
};

const options = Object.keys(sortFieldToString);

export default Ember.Component.extend({
  sort: null,
  options
});
