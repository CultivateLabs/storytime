class Storytime.Dashboard.BlogPosts
  initNew: ()->
    @editor = new Storytime.Dashboard.Posts()
    @editor.initNew()

  initEdit: ()->
    @editor = new Storytime.Dashboard.Posts()
    @editor.initEdit()

  initCreate: ()->
    @editor = new Storytime.Dashboard.Posts()
    @editor.initCreate()

  initUpdate: ()->
    @editor = new Storytime.Dashboard.Posts()
    @editor.initUpdate()