export default function ($) {
  let elem = $('#how-it-works');
  let options = {
    animationIn: "scale-in-up",
    animationOut: "scale-out-down"
  };
  let reveal = new Foundation.Reveal(elem, options);

  let el = $('#how-orbit');
  let orbOpt = {
    autoPlay: false,
    infiniteWrap: false
  };
  let orbit = new Foundation.Orbit(el, orbOpt);

};
