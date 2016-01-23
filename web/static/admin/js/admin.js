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

$('table').each(function () {
  $(this).DataTable({
    // STOP ALL THE THINGS
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
  // Put neat little sorting icons on all the things that are sortable!
  $(this).find('th:not(:empty)').each(function () {
    $(this).append('<span class="glyphicon glyphicon-sort"></span>');
  });
})
