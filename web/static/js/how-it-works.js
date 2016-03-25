export default function ($) {
  let elem = $('#how-it-works');
  let options = {
    animationIn: "scale-in-up",
    animationOut: "scale-out-down"
  };
  let reveal = new Foundation.Reveal(elem, options);
  //open automatically after 2.5 seconds
  let seen = !!Cookies.get('howseen');
  if(!seen) {
    setTimeout(function() {
      reveal.open();
    },2500);
  }

  let el = $('#how-orbit');
  let orbOpt = {
    autoPlay: false,
    infiniteWrap: false
  };
  let orbit = new Foundation.Orbit(el, orbOpt);

  elem.on("closed.zf.reveal", function() {
    Cookies.set('howseen', true, { expires: 2 });
  });


};
