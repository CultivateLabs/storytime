class Storytime.Dashboard.Editor
  init: () ->
    self = @

    (new Storytime.Dashboard.Contenteditable()).init()

    mediaInstance = @initMedia()
    (new Storytime.Dashboard.Wysiwyg()).init()

    # Title character limit
    title_character_limit = $("#title_character_limit").data("limit")
    $("#title_character_limit").html title_character_limit - $("#post_title").val().length

    $("[data-input='#post_title']").keypress((e) ->
      e.preventDefault() if (e.which is 32 or e.which > 0x20) and ($("#post_title").val().length > title_character_limit - 1)
      return
    ).keyup(->
      $("#title_character_limit").html title_character_limit - $("#post_title").val().length
      return
    )

    # Excerpt character limit
    excerpt_character_limit = $("#excerpt_character_limit").data("limit")
    $("#excerpt_character_limit").html excerpt_character_limit - $("#post_excerpt").val().length

    $("#post_excerpt").keypress((e) ->
      e.preventDefault() if (e.which is 32 or e.which > 0x20) and ($("#post_excerpt").val().length > excerpt_character_limit - 1)
      return
    ).keyup(->
      $("#excerpt_character_limit").html excerpt_character_limit - $("#post_excerpt").val().length
      return
    )

    if $(".edit_post").length
      form = $(".edit_post").last()

      $("#preview_post").click(->
        self.autosavePostForm()
        return
      )

      if $("#main").data("preview")
        window.open $("#preview_post").attr("href")
    else
      form = $(".new_post").last()

      $("#preview_post").click(->
        form.data "unsaved-changes", false
        
        $("<input name='preview' type='hidden' value='true'>").insertAfter($(".new_post").children().first())
        $(".new_post").submit()
        return
      )

    # Setup Chosen select field
    @initChosen()

    # Setup datepicker
    $(".datepicker").datepicker
      dateFormat: "MM d, yy"

    # Setup timepicker
    $(".timepicker").timepicker
      showPeriod: true

    # On modal show initialize media upload
    $(document).on 'shown.bs.modal', () ->
      mediaInstance.initUpload()
      return

    # Add new tags
    $("#post_tag_ids").next("div").find(".search-field").children("input").on 'keyup', (e) ->
      if e.which is 13 and $("#post_tag_ids").next("div").find(".search-field").children("input").val().length > 0
        searched_tag = $("#post_tag_ids").next("div").find(".search-field").children("input").val()
        $("#post_tag_ids").append('<option value="nv__' + searched_tag + '">' + searched_tag + '</option>')

        selected_tags = $("#post_tag_ids").val() || []
        selected_tags.push "nv__#{searched_tag}"

        $("#post_tag_ids").val selected_tags
        $("#post_tag_ids").trigger 'chosen:updated'
      return

    # Set published field on Publish button click
    $(".publish").on 'click', () ->
      $("#post_published").val(1)
      form.data "unsaved-changes", false
      return

    # Add handler to monitor unsaved changes
    addUnloadHandler(form)
    return

  initMedia: ()->
    mediaInstance = new Storytime.Dashboard.Media()
    mediaInstance.initPagination()
    mediaInstance.initInsert()
    mediaInstance.initFeaturedImageSelector()
    mediaInstance.initSecondaryImageSelector()
    mediaInstance.initImageSelector()

    $(document).on 'shown.bs.modal', ()->
      mediaInstance.initUpload()
      return

    mediaInstance

  initChosen: () ->
    $(".chosen-select").chosen
      no_results_text: "No results were found... Press 'Enter' to create a new tag named "
      placeholder_text_multiple: "Select or enter one or more Tags"
      search_contains: true
      width: '100%'
      
  autosavePostForm: () ->
    self = @
    post_id = $("#main").data("post-id")
    dashboard_namespace = $("#main").data("dashboard-namespace")

    data = []
    data.push {name: "post[draft_content]", value: $("#post_draft_content").val()}

    form = if $(".edit_post").length then $(".edit_post").last() else $(".new_post").last()
    form.data "unsaved-changes", false
 
    $.ajax(
      type: "POST"
      url: "#{dashboard_namespace}/posts/#{post_id}/autosaves"
      data: data
    )

  updateLater: (timer) ->
    self = @
    timer = 120000  unless timer?

    form = if $(".edit_post").length then $(".edit_post").last() else $(".new_post").last()

    timeoutId = window.setTimeout((->
      if form.data("unsaved-changes") is true
        self.autosavePostForm().done(->
          self.updateLater timer

          time_now = new Date().toLocaleTimeString()
          $("#draft_last_saved_at").html "Draft saved at #{time_now}"
          return
        ).fail(->
          console.log "Something went wrong while trying to autosave..."
          return
        )

        return
      else
        self.updateLater timer
        return
    ), timer)
    return

  addUnloadHandler = (form) ->
    form.find("input, textarea").on("keyup", ->
      form.data "unsaved-changes", true
      return
    )

    $(".save").click(->
      form.data "unsaved-changes", false
      return
    )

    $(window).on "beforeunload", ->
      return "You haven't saved your changes." if form.data "unsaved-changes"
