import Ember from 'ember';

const {computed, get} = Ember;

export default Ember.Component.extend({
  clearButtonLabel: null,
  currentValue: null,
  options: null,
  labelPath: null,
  valuePath: null,
  selectedValues: null,

  isFiltering: computed('valuePath', 'selectedValues.[]', 'options.[]', {
    get () {
      let {valuePath, selectedValues} = this.getProperties('valuePath', 'selectedValues');
      let optionValues = this.get('options').mapBy(valuePath);

      return selectedValues.any(v => optionValues.contains(v));
    }
  }),

  displayableOptions: computed('labelPath', 'valuePath', 'selectedValues.[]', 'options.[]', {
    get () {
      let {labelPath, valuePath, selectedValues, options}
        = this.getProperties('labelPath', 'valuePath', 'selectedValues', 'options');

      return options.map(option => {
        let value = get(option, valuePath);
        let label = get(option, labelPath);
        let selected = selectedValues.contains(value);

        return {label, selected, value};
      });
    }
  }),

  actions: {
    select (value, ev) {
      // stop foundation from being buggy and closing the modal
      ev.stopPropagation();
      return this.attrs.onSelect(value);
    }
  }
});
