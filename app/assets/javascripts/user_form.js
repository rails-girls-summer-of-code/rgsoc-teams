$(function () {
  $('.form-group.user_company_name').toggle($('#user_is_company').checked);
  $('.form-group.user_company_info').toggle($('#user_is_company').checked);

  $('#user_is_company').change(function () {
     $('.form-group.user_company_name').toggle(this.checked);
     $('.form-group.user_company_info').toggle(this.checked);
  }).change(); //ensure visible state matches initially


   //update coach availability

   $(function () {
      var $update_availability = $('[data-behavior="update_availability"]');
      $update_availability.on('click',function(){
        var url = $(this).data("url");
        updateAvailability(url);
      });
    });

   function updateAvailability(url) {
      $.ajax({
        method: 'PUT',
        url: url,
        success: updateBtnName
      });
    }

    function updateBtnName() {
      var $update_availability = $('[data-behavior="update_availability"]');
      $update_availability.html("Successful updated");
    }
});


$(window).on('DOMContentLoaded', function() {
  if (/users\/\d+\/edit/.test(window.location.pathname) && window.location.hash === '#application_specific') {
    $('#collapseApplicationSpecificInfo').addClass('in');
    $('html, body').scrollTop($('#application_specific').offset().top);
  }
});