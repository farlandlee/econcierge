import Ember from 'ember';

const {
  $,computed
} = Ember;

export default Ember.Component.extend({
  lightGalleryImages: computed({
    get () {
      let lightGalleryImages = [];
      this.$('li','.photos-source').each(function(){
        lightGalleryImages.push({
          src:$(this).data('src')
        });
      });
      return lightGalleryImages;
    }
  }),

  actions: {
    showLightGallery() {
      let lightGalleryImages = this.get('lightGalleryImages');
      if(lightGalleryImages.length > 0) {
        $(this).lightGallery({
          dynamic:true,
          html:true,
          counter: true,
          controls: true,
          loop: true,
          closable: false,
          dynamicEl: lightGalleryImages,
          download: false
        });
      }
    }
  }

});
