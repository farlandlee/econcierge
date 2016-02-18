import Ember from 'ember';

const {computed} = Ember;

export default Ember.Component.extend({
  tagName: '',

  currentExperience: null,
  experiences: null,

  nextExperience: computed('currentExperience', 'experiences.[]', {
    get () {
      let experiences = this.get('experiences');
      let experience = this.get('currentExperience');

      var nextIndex = experiences.indexOf(experience) + 1;
      nextIndex = nextIndex > experiences.get('length') - 1 ? 0 : nextIndex;

      return experiences.objectAt(nextIndex);
    }
  })
});
