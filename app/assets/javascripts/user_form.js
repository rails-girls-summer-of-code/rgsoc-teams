$(function () {
  $('.form-group.user_company_name').toggle($('#user_is_company').checked);
  $('.form-group.user_company_info').toggle($('#user_is_company').checked);

  $('#user_is_company').change(function () {
     $('.form-group.user_company_name').toggle(this.checked);
     $('.form-group.user_company_info').toggle(this.checked);
  }).change(); //ensure visible state matches initially

});


$(window).on('DOMContentLoaded', function() {
  if (/users\/\d+\/edit/.test(window.location.pathname) && window.location.hash === '#application_specific') {
    $('#collapseApplicationSpecificInfo').addClass('in');
    $('html, body').scrollTop($('#application_specific').offset().top);
  }

   //update coach availability

   $(function () {
      var $update_availability = $('[data-behavior="update_availability"]');
      $update_availability.on('click',function(){
        var url = "/users/current/update_availability";
        updateAvailability(url);
      });
    });

   function updateAvailability(url) {
      $.ajax({
        type:     'PUT',
        url:      url
      });
    }
  });
});