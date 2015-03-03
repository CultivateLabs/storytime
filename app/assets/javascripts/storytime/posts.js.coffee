class Storytime.Dashboard.Posts
  initNew: ()->
    @editor = new Storytime.Dashboard.Editor()
    @editor.init()
    @initCollapse()

  initEdit: ()->
    @editor = new Storytime.Dashboard.Editor()
    @editor.init()
    @initCollapse()

  initCreate: ()->
    @editor = new Storytime.Dashboard.Editor()
    @editor.init()
    @initCollapse()

  initUpdate: ()->
    @editor = new Storytime.Dashboard.Editor()
    @editor.init()
    @initCollapse()

  initCollapse: ()->
    $('body').on 'keydown', (e) ->
      if e.which == 27
        $(".post-action-panel.in").collapse("hide")

    $(".post-action-panel").on "show.bs.collapse", ->
      $(".post-action-panel").removeClass "in"
      $(".scroll-panel-header").fadeOut
        duration: 'fast'
        easing: 'swing'
      $(".scroll-panel-body").scrollTop(0)
      $(".scroll-panel-body").animate({top: "0"}, 'fast', 'swing')

    $(".post-action-panel").on "shown.bs.collapse", ->
      $(".chosen-select").trigger("chosen:updated")

    $(".post-action-panel").on "hide.bs.collapse", ->
      top = $(".scroll-panel-body").data("top")
      $(".scroll-panel-header").fadeIn
        duration: 'fast'
        easing: 'swing'
      $(".scroll-panel-body").animate({top: top}, 'fast', 'swing')