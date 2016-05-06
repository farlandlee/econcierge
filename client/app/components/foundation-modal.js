/* globals Foundation */
import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['reveal','grid-modal'],

  didInsertElement () {
    let el = this.$();
    // needed for hacking, have to save it *before* we create the reveal.
    let parent = el.parent();
    let reveal = new Foundation.Reveal(el, {});
    this._hackFoundation62(reveal, parent);
    reveal.open();
    el.on('closed.zf.reveal', () => {
      this._close();
    });
    this.set('reveal', reveal);
  },

  _hackFoundation62 (reveal, parent) {
    /**
     * Yes, this is the grossest thing in our codebase.
     * Foundation appends its overlays to body, and then appends
     * the reveal itself to that overlay. (If you choose to not have an overlay,
     * they then just directly append you to the body)
     * This hack
     * 1. creates a new overlay (in the parent of this modal)
     * 2. manually setup the foundation events on that overlay
     * 2. insert the overlay within the original parent element of this component
     * 2. sets the reveal's overlay to the one we just created
     * 3. moves our element back to where it should be - in the overlay we made
     * 4. destroys the overlay foundation made
    **/
    let $misplacedOverlay = reveal.$overlay;
    // need the if for tests, where we are mocking Foundation
    if ($misplacedOverlay) {
      let $overlay = Ember.$('<div></div>').addClass('reveal-overlay')
        .attr({ 'tabindex': -1, 'aria-hidden': true })
        .on('click.zf.reveal', function (e) {
          // modified from a c/p of foundation's code
          if (
            e.target === reveal.$element[0] ||
            Ember.$.contains(reveal.$element[0], e.target) ||
            // this line is custom. makes foundation modal
            // play nice with an embedded flatpickr
            e.isDefaultPrevented()
          ) {
            return;
          }
          reveal.close();
        })
        .appendTo(parent);
      reveal.$overlay = $overlay;
      this.$().detach().appendTo($overlay);
      $misplacedOverlay.remove();
    }
  },

  willDestroyElement () {
    this.$().off('closed.zf.reveal');
    this.get('reveal').close();
  },

  _close () {
    this.get('reveal').close();
    return this.attrs.onClose();
  },

  actions: {
    close () {
      return this._close();
    }
  }
});
