export default function ($) {
  // this will only open the fulloverlay selector
  $(document).on('click', '.full-overlay-select-opener', function() {
    $('#full-overlay-select-list-container, .full-overlay-select-opener').addClass('open');
    $('.purechat, .purechat-mobile-widget-button, .page-footer').addClass('hidden');
  });

  // Close when clicking outside
  $('body').on('click', '#full-overlay-select-list-container', function() {
    $('#full-overlay-select-list-container, .full-overlay-select-opener').removeClass('open');
    $('.purechat, .purechat-mobile-widget-button, .page-footer').removeClass('hidden');
  });

  // Keyboard events
  $(document).on('keydown','.full-overlay-select-opener', function(event) {
    event.stopPropagation();
    let dropdown = $('#full-overlay-select-list-container');

    // Space or Enter
    if (event.keyCode == 32 || event.keyCode == 13) {
        let href = $('.selected',dropdown).attr('href');
        // this is basically just for development
        if( typeof href == 'undefined' || href.slice(-1) === '#') {
          $('.selected',dropdown).click();
        }
        else {
          window.location.href = href;
        }
    // Down
    } else if (event.keyCode == 40) {
      // test if element has category children (i.e., nested category)
      let next = $('.selected',dropdown).siblings('ul').find('a').first();
      if(next.length) {
        dropdown.find('.selected').removeClass('selected');
        next.addClass('selected');
        return false;
      }

      //check if this just has a regular sibling (activity or category)
      next = $('.selected',dropdown).parent('li').next().find('a').first();
      if(next.length) {
        dropdown.find('.selected').removeClass('selected');
        next.addClass('selected');
        return false;
      }

      //check to see if this is a nested category
      next = $('.selected',dropdown).parent('li').parents('li').next().find('a').first();
      if(next.length) {
        dropdown.find('.selected').removeClass('selected');
        next.addClass('selected');
        return false;
      }
    // Up
    } else if (event.keyCode == 38) {
      //this should cover previous element with or without categories
      let prev = $('.selected',dropdown).parent().prev().find('a').last();
      if (prev.length) {
        dropdown.find('.selected').removeClass('selected');
        prev.addClass('selected');
        return false;
      }
      prev = $('.selected',dropdown).parents('ul').siblings('a').last();
      if (prev.length) {
        dropdown.find('.selected').removeClass('selected');
        prev.addClass('selected');
        return false;
      }
    // Esc
    } else if (event.keyCode == 27) {
        dropdown.trigger('click');
    }
  });
};
