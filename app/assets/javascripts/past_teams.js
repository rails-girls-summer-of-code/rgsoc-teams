$(function() {
  $selectedYear = $('select#past_teams');

  $selectedYear.on('change', function(){
    var yearParam = "?year="+this.value;
    var newUrl;
    var removed = window.location.search;

    if(removed.length>0){
      newUrl = location.href.replace(removed, yearParam);
    } else{
      newUrl = location.href+yearParam;
    }
    window.location.href = newUrl;
  });
});
