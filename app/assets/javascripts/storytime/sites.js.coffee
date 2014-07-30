class Storytime.Dashboard.Sites
  initNew: ()->
    @initForm()

  initEdit: ()->
    @initForm()

  initUpdate: ()->
    @initForm()

  initForm: ()->
    $("#site_root_page_content").change ()->
      if @value == "page"
        $(".site_root_post_id").removeClass("hide")
      else
        $(".site_root_post_id").addClass("hide")