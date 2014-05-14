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
        $(".site_selected_root_page_id").removeClass("hide")
      else
        $(".site_selected_root_page_id").addClass("hide")