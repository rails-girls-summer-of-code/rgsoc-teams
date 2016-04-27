class RatingSidebar
  constructor: ->
    @ratingsContainer = $("[data-behavior='rating-sidebar']")
    @popovers = $('[data-toggle="popover"]')

    if @ratingsContainer.length > 0
      @initSidebar()
      @initPopovers()

  initPopovers: ->
    @popovers.popover()

  initSidebar: ->
    $(window).on 'scroll', @handleScroll

  handleScroll: (e) =>
    body = $('body')
    scrolledToThreshold = $(window).scrollTop() > 100
    if scrolledToThreshold
      body.addClass 'rating-fixed'
    else
      body.removeClass 'rating-fixed'

$ ->
  new RatingSidebar
