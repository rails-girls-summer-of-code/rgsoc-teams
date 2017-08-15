$(function() {
  var $selectedYear = $('select#past_teams');

  $selectedYear.on('change', function(){
    var yearParam = "?year="+this.value;
    window.location.search = yearParam;
  });
});