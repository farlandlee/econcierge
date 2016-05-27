$('a.slide').click(function (event) {
  event.preventDefault();

  let url = $(this).attr('href');
  let slideId = $(this).attr('data-slide-id');
  let kiosk = $(this).attr('data-kiosk');

  if (typeof ga === 'function') {
    ga('send', 'event', kiosk, 'ad click', slideId, {
      'hitCallback': () => { window.location = url; }
    });
  } else {
    window.location = url;
  }
});
