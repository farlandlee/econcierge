export default function ($) {

  let el = $('#kiosk-orbit');
  if(el.length) {
    let opt = {
      autoPlay: true,
      timerDelay: 3000,
      infiniteWrap: true
    };
    let orbit = new Foundation.Orbit(el, opt);
  }

};
