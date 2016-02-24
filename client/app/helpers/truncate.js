import Ember from 'ember';

export function truncate([text = ''], {limit = 30} = {limit: 30}) {
  if (text.length > limit){
    text = text.substr(0, limit - 3) + "...";
  }
  return text;
}

export default Ember.Helper.helper(truncate);
