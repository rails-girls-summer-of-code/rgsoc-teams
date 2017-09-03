class RatingSidebar {
  constructor() {
    this.handleScroll = this.handleScroll.bind(this);
    this.ratingsContainer = $("[data-behavior='rating-sidebar']");
    this.popovers = $('[data-toggle="popover"]');

    if (this.ratingsContainer.length > 0) {
      this.initSidebar();
      this.initPopovers();
    }
  }

  initPopovers() {
    return this.popovers.popover();
  }

  initSidebar() {
    return $(window).on('scroll', this.handleScroll);
  }

  handleScroll(e) {
    const body = $('body');
    const scrolledToThreshold = $(window).scrollTop() > 100;
    if (scrolledToThreshold) {
      return body.addClass('rating-fixed');
    } else {
      return body.removeClass('rating-fixed');
    }
  }
}

$(() => new RatingSidebar);
