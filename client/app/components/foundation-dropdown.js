/* global Foundation */
import Ember from 'ember';

/**
 When you use this, you need to provide an "anchor" element to go with it,
 or a lot Foundation's code will vomit all over your face.
 There are two steps to setting up an anchor:
 1. give the foundation-dropdown an id
 2. make an element outside of the dropdown with `data-toggle="{{dropdown-id}}"`
 3. you probably want to prevent default on any events that element makes when clicked,
    and handle showing the dropdown yourself via the `show` attribute

(see product filters for example use)
 */

export default Ember.Component.extend({
  hover: false,
  hoverPane: true,
  vOffset: 1,
  hOffset: 1,
  closeOnClick: false,
  alignment: 'right',
  show: false,

  classNames: ['dropdown-pane'],

  didInsertElement () {
    let element = this.$();
    let options = this.getProperties(
      'hover', 'hoverPane', 'vOffset', 'hOffset', 'closeOnClick'
    );
    let dropdown = new Foundation.Dropdown(element, options);
    this.setProperties({dropdown});

    element.on('hide.zf.dropdown', () => {
      if (this.attrs.onClose) {
        this.attrs.onClose();
      }
    });
  },

  didRender () {
    let show = this.get('show');
    if (show) {
      this.get('dropdown').open();
    } else {
      this.get('dropdown').close();
    }
  },

  willDestroyElement () {
    this.get('dropdown').destroy();
  }
});
