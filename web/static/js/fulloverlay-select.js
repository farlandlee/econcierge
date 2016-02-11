jQuery(function($){
  /* Event listeners */

  // Open/close
  $(document).on('click', '.full-overlay-select', function(event) {
    event.stopPropagation();
    var dropdown = $(this);

    if (!dropdown.hasClass('open') && dropdown.find('.selected').length === 0) {
      dropdown.find('.selected').removeClass('selected');
      dropdown.find('a').first().addClass('selected');
    }

    $('.full-overlay-select').not(dropdown).removeClass('open');
    dropdown.toggleClass('open');

    if (dropdown.hasClass('open')) {
      $('.page-header').css('z-index',1);
    } else {
      $('.page-header').css('z-index',100);
      dropdown.focus();
    }
  });

  // Close when clicking outside
  $(document).on('click', function(event) {
    $('.full-overlay-select').removeClass('open');
  });

  // Keyboard events
  $(document).on('keydown', '.full-overlay-select', function(event) {
    event.stopPropagation();
    var dropdown = $(this);

    // Space or Enter
    if (event.keyCode == 32 || event.keyCode == 13) {

      if (dropdown.hasClass('open')) {
        var href = $('.selected',dropdown).attr('href');
        // this is basically just for development
        if(href.slice(-1) === '#') {
          $('.selected',dropdown).click();
        }
        else {
          window.location.href = href;
        }
      } else {
        dropdown.trigger('click');
      }
      //return false;
    // Down
    } else if (event.keyCode == 40) {
      if (!dropdown.hasClass('open')) {
        dropdown.trigger('click');
      } else {
        var next = $('.selected',dropdown).parent('li').next().children('a').first();
        if (next.length > 0) {
          dropdown.find('.selected').removeClass('selected');
          next.addClass('selected');
        }
      }
      return false;
    // Up
    } else if (event.keyCode == 38) {
      if (!dropdown.hasClass('open')) {
        dropdown.trigger('click');
      } else {
        var prev = $('.selected',dropdown).parent('li').prev().children('a').first();
        if (prev.length > 0) {
          dropdown.find('.selected').removeClass('selected');
          prev.addClass('selected');
        }
      }
      return false;
    // Esc
    } else if (event.keyCode == 27) {
      if (dropdown.hasClass('open')) {
        dropdown.trigger('click');
      }
    // Tab
    } else if (event.keyCode == 9) {
      if (dropdown.hasClass('open')) {
        return false;
      }
    }
  });
});
