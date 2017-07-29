$(function() {
  $('.selected_conference').on("change", function() {
    var selected = $(this);
      $("select option").attr("disabled",false);
      disableOptions();
      verifyNoneSelected(selected);
    });

  function disableOptions(){
    $("select option").filter(function(){
      var bSuccess=false;
      var selectedEl=$(this);
      $("select option:selected").each(function(){
        if($(this).val()===selectedEl.val() && $(this).val() !== ''){
          bSuccess=true;
          return false;
        }
      });
        return bSuccess;
      }).css("display","none");
    }

  function verifyNoneSelected($select){
    var $optionSelected = $select.find('option:selected');
    var $parent = $select.parent('.fields');
    $parent.find('.destroy_option').val($optionSelected.val() === '');
  }
});