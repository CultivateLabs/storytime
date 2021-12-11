$ ->
  $("body").on "click", "[data-toggle='off-canvas']", (e) ->
    e.preventDefault()
    if $("#off-canvas-overlay").length == 0
      $("#main").before("<div id='off-canvas-overlay'></div>")
    target = $(this).data("target")
    $(target).toggleClass("in")

  $("body").on "click touchstart", "#off-canvas-overlay", (e) ->
    e.preventDefault()
    $(".off-canvas.in").removeClass("in")

  $("body").on "click", "[data-toggle='columns']", (e) ->
    e.preventDefault()
    $('#right').toggleClass('hidden-xs')
    $('#left').toggleClass('hidden-xs')
