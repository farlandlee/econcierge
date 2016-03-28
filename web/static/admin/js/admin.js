import "deps/phoenix_html/web/static/js/phoenix_html";
import "./tab_activation";

$('.chosen-select:visible').chosen();
// sync img tag with data-img-for attribute to
// whatever input it identifies
$('[data-img-for]').each(function() {
  let $img = $(this);
  let inputId = $img.data('img-for');
  $(`${inputId}`).change(e => {
    $img.attr('src', URL.createObjectURL(e.target.files[0]))
  });
});

$('table').each(function () {
  $(this).DataTable({
    // STOP ALL THE THINGS
    order: [],
    searching: false,
    paging: false,
    bInfo: false,
    // SHHHHHHHHHHHHHH
    language: {
      emptyTable: false,
      zeroRecords: false
    },
    aoColumnDefs: [
      // last row (Actions) isn't sortable
      {bSortable: false, aTargets: [-1]}
    ]
  });
});

// Put neat little sorting icons on all the things that are sortable!
$('th:not(:last-child)').each(function () {
  $(this).append('<span class="glyphicon glyphicon-sort table-icon"></span>');
});

//add tinymce to product_description
tinymce.init({
  selector: '#product_description',
  plugins: 'advlist autolink link image lists charmap print preview autoresize code textcolor colorpicker media wordcount',
  toolbar: [
    "bold italic underline strikethrough | alignleft aligncenter alignright alignjustify | formatselect bullist numlist outdent indent | image media",
    "fontselect fontsizeselect forecolor backcolor | blockquote subscript superscript | cut copy paste undo redo removeformat"
  ],
  image_caption: true,
  browser_spellcheck: true,
  media_live_embeds: true
});
