import "deps/phoenix_html/web/static/js/phoenix_html";

$('.chosen-select').chosen();
// sync img tag with data-img-for attribute to
// whatever input it identifies
$('[data-img-for]').each(function() {
  let $img = $(this);
  let inputId = $img.data('img-for');
  $(`${inputId}`).change(e => {
    $img.attr('src', URL.createObjectURL(e.target.files[0]))
  });
});
