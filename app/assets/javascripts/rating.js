$(function(){
  function handleScroll(e) {
    var body = $('body');
    var scrolledToThreshold = $(window).scrollTop() > 100;
    if (scrolledToThreshold) {
      return body.addClass('rating-fixed');
    } else {
      return body.removeClass('rating-fixed');
    }
  }

  function initSidebar() {
    $(window).on('scroll', handleScroll);
  }

  function initPopovers() {
    $('[data-toggle="popover"]').popover();
  }


  var ratingsContainer =  $("[data-behavior='rating-sidebar']");
  if (ratingsContainer.length > 0) {
    initSidebar();
    initPopovers();
  }
});
