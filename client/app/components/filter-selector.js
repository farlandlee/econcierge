import Ember from 'ember';

const {computed} = Ember;

export default Ember.Component.extend({
  title: null,
  currentValue: null,
  options: null,
  labelPath: null,
  valuePath: null,
  selectedValues: null,

  displayableOptions: computed('labelPath', 'valuePath', 'selectedValues.[]', 'options.[]', {
    get () {
      let {labelPath, valuePath, selectedValues, options}
        = this.getProperties('labelPath', 'valuePath', 'selectedValues', 'options');

      return options.map(option => {
        let value;
        let label;
        let selected;
        if (option.get) {
          value = option.get(valuePath);
          label = option.get(labelPath);
        } else {
          value = option[valuePath];
          label = option[labelPath];
        }
        selected = selectedValues.contains(value);
        return {label, selected, value};
      });
    }
  }),

  actions: {
    select (value) {
      return this.attrs.onSelect(value);
    }
  }
});
