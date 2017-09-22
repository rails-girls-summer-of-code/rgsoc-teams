$(function () {
  $('[data-form="new-conference-form"]').on('ajax:success',
    function(e, data) {
      var conference = data;
      var select = $('[data-conference-preferences="conference-preferences"] select');
      var regionSelector = 'optgroup[label="' +  conference.region + '"]';

      $('[data-modal="new-conference-modal"]').modal('hide');
      if(select.find(regionSelector).length == 0) {
        select.append('<optgroup label="' + conference.region + '"></optgroup>');
      }

      select.find(regionSelector).append('<option value="' + conference.id + '">' + conference.name + '</option>');

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
