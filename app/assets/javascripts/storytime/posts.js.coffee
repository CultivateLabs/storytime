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
    $(".post-action-panel").on "show.bs.collapse", ->
      $(".post-action-panel").removeClass "in"