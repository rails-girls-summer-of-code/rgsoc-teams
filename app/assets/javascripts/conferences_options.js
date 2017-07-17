$(function() {
  $('#team_attendances_attributes_0_conference_id').on("change", function() {
      $("select option").attr("disabled",false);
      DisableOptions();
    });

  function DisableOptions(){
    $("select option").filter(function(){
      var bSuccess=false;
      var selectedEl=$(this);
      $("select option:selected").each(function(){
        if($(this).val()==selectedEl.val()){
          bSuccess=true;
          return false;
        }
      });
        return bSuccess;
      }).css("display","none");
    };
});
