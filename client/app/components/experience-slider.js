import Ember from 'ember';

const {computed} = Ember;

export default Ember.Component.extend({
  tagName: '',

  experiences: null,
  currentStartIndex: 0,

  // We want a local copy of experiences that excludes the current experience
  filteredExperiences: computed('currentExperience', 'experiences.[]',{
    get() {
      let currentExperienceId = this.get('currentExperience.id');
      let filteredExperiences = this.get('experiences').rejectBy('id', currentExperienceId);
      return filteredExperiences.sortBy('name');
    }
  }),

  visibleExperiences: computed('filteredExperiences.[]', 'currentStartIndex', {
    get() {
      let length = this.get('filteredExperiences.length');
      if (length > 3) {
        let first = this.get('currentStartIndex');
        let second = (first + 1) % length;
        let third = (first + 2) % length;
        return this.get('filteredExperiences').objectsAt([first, second, third]);
      } else {
        return this.get('filteredExperiences');
      }
    }
  }),

  isSliderVisible: computed('filteredExperiences.[]', {
    get() {
      return this.get('filteredExperiences.length') > 3;
    }
  }),

  actions: {
    shiftRight() {
      if (this.get('currentStartIndex') < this.get('filteredExperiences.length') - 1) {
        this.incrementProperty('currentStartIndex');
      } else {
        this.set('currentStartIndex', 0);
      }
    }
  }
});
