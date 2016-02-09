$(function () {
  $('.js-tabs .js-tab').click(function(e) {
    var tab_id = $(e.target).data('tab-id');
    $('.js-content-tabs-wrapper .js-content-tab div').hide();
    $('.js-content-tabs-wrapper .js-content-tab[data-tab-id="' + tab_id + '"]').show();
  })
});
