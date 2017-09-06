$(function () {
  $('[data-form="new-conference-form"]').on('ajax:success',
    function(e, data) {
      var conference = data;
      var selected = $('[data-conference-preferences="conference-preferences"] select:first option:first');
      $('[data-modal="new-conference-modal"]').modal('hide');
      selected.prop('selected', 'selected');
      selected.val(conference.id);
      selected.text(conference.name);
      $(this).find('input[type!=hidden], select, textarea').val('');
    }
  );
  $('[data-form="new-conference-form"]').on('ajax:error',
    function(e, xhr) {
      if(xhr.status == 422) {
        var errors = JSON.parse(xhr.responseText);
        $('[data-errors="new-conference-modal-errors"]').removeClass('hidden').html('<ul></ul>');
        for(var i = 0; i < errors.length; i++) {
          $('[data-errors="new-conference-modal-errors"] ul').append('<li>' + errors[i] + '</li>');
        }
      }
    }
  );
});
