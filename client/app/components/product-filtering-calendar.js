/* globals introJs */
import GridCalendar from 'client/components/grid-calendar';

export default GridCalendar.extend({
  layoutName: 'components/grid-calendar',
  didInsertElement () {
    this._super(...arguments);

    let viewedIntro = localStorage.introjsViewed? true : false;

    let intro = introJs();

    intro.setOptions({
      steps: [
        {
          element: "#"+this.elementId + ' .selected-date',
          intro: "Select your desired date to see only those products available on it."
        },
      ],
      doneLabel: "Got it!",
      exitOnOverlayClick: true,
      exitOnEsc: true,
      showBullets: false
    });

    intro.oncomplete(function() {
      localStorage.introjsViewed = true;
    });

    if (!viewedIntro) {
      intro.start();
    }
  }
});
