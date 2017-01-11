(function() {
  var apiKey  = GOOGLE_MAPS_API_KEY;
  var baseURL = 'https://maps.googleapis.com/maps/api/js';
  var opts    = { types: ['(cities)'] };
  var params  = {
    key:       apiKey,
    signed_in: true,
    libraries: 'places',
    language:  'en-US'
  };

  function init() {
    if (Boolean(apiKey)) { loadPlacesLib(); }
  }

  function loadPlacesLib() {
    $.ajax({
      cache:    true,
      url:      baseURL,
      data:     params,
      dataType: 'script',
      success:  initCityFields
    });
  }

  function initCityFields() {
    $(function () {
      var $fields = $('[data-behavior="city-autocomplete"]');
      if ($fields.length) { $fields.map(function() { addAutocomplete(this); }); }
    });
  }

  function addAutocomplete(field) {
    var autocomplete  = new google.maps.places.Autocomplete(field, opts);
    var $field        = $(field);
    var $latField     = $field.next('[data-behavior="location-lat"]');
    var $lngField     = $latField.next('[data-behavior="location-lng"]');
    var place;

    $field.focusin(function() { disableEnter(this); });

    autocomplete.addListener('place_changed', function() {
      place = autocomplete.getPlace();
      var location = place.geometry.location;
      $latField.val(location.lat());
      $lngField.val(location.lng());
    });

    $field.focusout(function() {
      validateValues(this, place, $latField, $lngField);
    });
  }

  function disableEnter(field) {
    $(field).keypress(function(e) {
      if (e.keyCode === 13) { e.preventDefault(); }
    });
  }

  function validateValues(field, place, $latField, $lngField) {
    var currentText = $(field).val();
    var blank       = !currentText.length;
    if (blank || (place.formatted_address !== currentText)) {
      $latField.removeAttr('value');
      $lngField.removeAttr('value');
    }
  }

  init();
})();
