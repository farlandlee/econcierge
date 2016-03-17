export default function ($) {
  if($('.home').length > 0) {
    var howHeight = $("#how-it-works").outerHeight();
    setInterval(function(){
      if($("#how-it-works").hasClass('active')) {
        howHeight = $("#how-it-works").outerHeight();
        if($(document).scrollTop() > howHeight) {
          $(".close-button","#how-it-works").click();
        }
      }
    }, 300);
    $("#how-it-works")
    .on("on.zf.toggler", function(e) {
      $(this).addClass('active');
    })
    .on("off.zf.toggler", function(e) {
      $(this).removeClass('active');
    }).on('close.zf.trigger', function(e) {
      $(this).removeClass('active');
    });
  }
};
