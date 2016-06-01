$('a.slide').click(function (event) {
  event.preventDefault();

  let url = $(this).attr('href');
  let category = $(this).attr('data-category');
  let slideId = $(this).attr('data-slide-id');

  if (typeof ga === 'function') {
    ga('send', 'event', category, 'Slide Click', slideId, {
      'hitCallback': () => { window.location = url; }
    });
  } else {
    window.location = url;
  }
});
