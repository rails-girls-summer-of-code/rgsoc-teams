$(function() {
    $('#team_attendances_attributes_0_conference_id').on("change", function() {
      $("select option").attr("disabled",false);
      DisableOptions();
      //let contentSelected = $('#team_attendances_attributes_0_conference_id option:selected').val();
      //$("#team_attendances_attributes_1_conference_id")[contentSelected].remove();
    });


        function DisableOptions(){
          debugger;

          $("select option").filter(function()
              {
                    var bSuccess=false; //will be our flag to know it coincides with selected value
                    var selectedEl=$(this);
                    $("select option:selected").each(function()
                    {

                        if($(this).val()==selectedEl.val())
                        {
                             bSuccess=true; //it coincides we will return true;
                             return false; // this serves to break the each loop
                         }

                    });
                    return bSuccess;
         }).css("display","none");

    };

});
