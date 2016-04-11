import Ember from 'ember';

const {computed, get} = Ember;

export default Ember.Component.extend({
  tagName: 'button',
  classNames: 'filter-label',

  filters: [],
  value: null,
  labelPath: 'name',
  valuePath: 'slug',

  label: computed('filters.[]', 'value', 'labelPath', 'valuePath', {
    get () {
      let {filters, value, labelPath, valuePath} = this.getProperties('filters', 'value', 'labelPath', 'valuePath');
      let filter = filters.findBy(valuePath, value);
      // might be a POJO, so use Ember.get
      return get(filter, labelPath);
    }
  }),

  click () {
    return this.attrs.onClick();
  }
});
