class Storytime.Dashboard.Editor
  init: () ->
    self = @

    (new Storytime.Dashboard.Contenteditable()).init()
    (new Storytime.Dashboard.CharacterCounter()).init()
    @initChosen()
    (new Storytime.Dashboard.Tags()).init()

    mediaInstance = @initMedia()
    (new Storytime.Dashboard.Wysiwyg()).init()
    
    form = $(".post-form")
    
    $("#medium-editor-post").keyup ->  
      form.data "unsaved-changes", true

    if $(".edit-post-form").length
      $("#preview_post").click(->
        self.autosavePostForm()
        return
      )

      self.setAutosaveInterval(10000) unless window.Storytime.test_env

      if $("#main").data("preview")
        window.open $("#preview_post").attr("href")
    else
      $("#preview_post").click(->
        form.data "unsaved-changes", false
        
        $("<input name='preview' type='hidden' value='true'>").insertAfter(form.children().first())
        form.submit()
        return
      )

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

    # Set published field on Publish button click
    # TODO: This should not rely on javascript. Should make publish button a submit button and look for the button name in the controller to set published = true
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
    postType = $(".post-form").data("post-type")
    
    autosaveUrl = $(".post-form").data("autosave-url")

    data = []
    data.push {name: "#{postType}[draft_content]", value: $(".draft-content-input").val()}

    form = $(".post-form")
    form.data "unsaved-changes", false
 
    deferred = $.ajax(
      type: "POST"
      url: autosaveUrl
      data: data
    )

    deferred.done ()->
      time_now = new Date().toLocaleTimeString()
      $("#draft_last_saved_at").html "Draft saved at #{time_now}"
      return

    return deferred

  setAutosaveInterval: (timer) ->
    self = @
    timer = 120000 unless timer?

    form = $(".post-form")
    
    window.setTimeout((->
      
      if form.data("unsaved-changes") is true
        self.autosavePostForm().always(->
          self.setAutosaveInterval timer
          return
        )

        return
      else
        self.setAutosaveInterval timer
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
      if form.data("unsaved-changes") && !window.Storytime.test_env
        return "You haven't saved your changes." 
