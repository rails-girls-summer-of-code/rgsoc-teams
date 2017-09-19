var exports;
var root = typeof exports !== 'undefined' && exports !== null ? exports : this;

root.sendPreview = function() {
  var sform = $($('[data-js="form-with-preview"]')[0].elements).not('input:hidden[name=_method]').serialize();
  $.ajax({
    type: 'POST',
    url: $('#preview-tab').data('ajax-path'),
    data: sform,
    success: function(data) {
      $('#preview-pane').html(data);
    }
  });
};
