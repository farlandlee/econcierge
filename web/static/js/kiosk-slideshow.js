export default function ($) {

  let el = $('#kiosk-orbit');
  if(el.length) {
    let opt = {
      autoPlay: true,
      infiniteWrap: true
    };
    let orbit = new Foundation.Orbit(el, opt);

    $.fn.swipeEvents = function() {
      return this.each(function() {

        var startX,
            startY,
            $this = $(this);

        function touchstart(event) {
          var touches = event.originalEvent.touches;
          if (touches && touches.length) {
            startX = touches[0].pageX;
            startY = touches[0].pageY;
            $this.on('touchmove', touchmove);
          }
        }

        function touchmove(event) {
          var touches = event.originalEvent.touches;
          if (touches && touches.length) {
            var deltaY = startY - touches[0].pageY;
            if (deltaY >= 100) {
              $this.trigger("swipeUp");
            }
            if (deltaY <= -100) {
              $this.trigger("swipeDown");
            }
            if (Math.abs(deltaY) >= 100) {
              $this.off('touchmove', touchmove);
            }
          }
        }
        $this.on('touchstart', touchstart);
      });
    };

    el.swipeEvents().on("swipeDown",  function(){
      window.location = $('#link-all-activities').attr('href');
    });
  }

};