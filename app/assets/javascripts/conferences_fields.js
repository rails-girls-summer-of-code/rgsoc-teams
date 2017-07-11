(function() {
  var conferencesURL = //put conferences url here;
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

  function addOptionsToSelect(select, value, text){
    select.append($'<option>', { value: value }).text(text));
  }

  function fetchConferences(params, callback){
    $.get({url: conferencesURL, success: callback})
  }

  function loadConferences(regionId) {
    //verify the region field - suppose that exists a region id
    fetchConferences({ region_id: regionId}, function(data){
      addOptionsToSelect($select, '', $select.data('prompt'));

      for(key in data){
        //suposing that exists a field for conferences id and name
        addOptionsToSelect($select, data[key].id, data[key].name);
      }
    })
  };

  return function(){
    $region_select = $('#region_selected');

    $region_select.on('change', function(){
      var regionId = $region_select.val(); //suppose that regiions have ids
      loadConferences(regionId);
    })
  }
})();
