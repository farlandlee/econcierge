import Ember from 'ember';

export default Ember.Component.extend({
  image: null,
  images: null,

  actions: {
    showLightGallery() {
      let images = this.get('images');
      if (images.length) {
        images = images.map(i => {
          return {src: i.full};
        });
        this.$().lightGallery({
          dynamicEl: images,
          dynamic:true,
          html:true,
          counter: true,
          controls: true,
          loop: true,
          closable: false,
          download: false
        });
      }
    }
  }

});
