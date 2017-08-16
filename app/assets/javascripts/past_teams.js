$(function() {
  var $selectedYear = $('[data-behaviour="switch-teams-year"]');

  $selectedYear.on('click', function(){
    var yearParam = "?year="+this.value;
    window.location.search = yearParam;
  });
});