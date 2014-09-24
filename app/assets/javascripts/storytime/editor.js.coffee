class Storytime.Dashboard.Editor
  init: () ->
    self = @

    mediaInstance = new Storytime.Dashboard.Media()
    mediaInstance.initPagination()
    mediaInstance.initInsert()
    mediaInstance.initFeaturedImageSelector()

    $(document).on 'shown.bs.modal', ()->
      mediaInstance.initUpload()

    $(".wysiwyg").wysihtml5 "deepExtend",
      parserRules:
        allowAllClasses: true
      html: true
      color: true
      customTemplates:
        "html": (locale, options)->
          size = if (options && options.size) then ' btn-'+options.size else ''
          return "<li>" +
              "<div class='btn-group'>" +
              "<a class='btn" + size + " btn-default' data-wysihtml5-action='change_view' title='" + locale.html.edit + "' tabindex='-1'><i class='glyphicon glyphicon-pencil'></i>&nbsp;&nbsp;Raw HTML Mode</a>" +
              "</div>" +
              "</li>"
        "image": (locale, options)->
            size = if (options && options.size) then ' btn-'+options.size else ''
            $modal = $("#insertMediaModal").remove()
            return "<li>" +
                $modal[0].outerHTML +
                "<a class='btn" + size + " btn-default' data-wysihtml5-command='insertImage' title='" + locale.image.insert + "' tabindex='-1'><i class='glyphicon glyphicon-picture'></i></a>" +
                "</li>";

    if $(".edit_post").length
      form = $(".edit_post").last()

      $("#preview_post").click(->
        self.autosavePostForm()
      )
      
      if $("#main").data("preview")
        $("#preview_post").trigger("click")
        window.open $("#preview_post").attr("href")
    else
      form = $(".new_post").last()

      $("#preview_new_post").click(->
        $("<input name='preview' type='hidden' value='true'>").insertAfter($(".new_post").children().first())
        $(".new_post").submit()
      )

    $('.wysihtml5-sandbox').contents().find('body').focus(->
      self.updateLater(10000) if $(".edit_post").length
      
      $('.wysihtml5-sandbox').contents().find('body').on('keyup', ->
        form.data "unsaved-changes", true
      )

      $('.wysihtml5-sandbox').contents().find('body').off('focus')
    )

    addUnloadHandler(form)


  autosavePostForm: () ->
    self = @
    post_id = $("#main").data("post-id")

    data = []
    data.push {name: "post[draft_content]", value: $("#post_draft_content").val()}

    $.ajax(
      type: "POST"
      url: "/dashboard/posts/#{post_id}/autosaves"
      data: data
    )


  updateLater: (timer) ->
    self = @
    timer = 120000  unless timer?

    timeoutId = window.setTimeout((->
      self.autosavePostForm().done(->
        self.updateLater(10000)

        time_now = new Date().toLocaleTimeString()
        $("#draft_last_saved_at").html "Draft saved at #{time_now}"
      ).fail(->
        console.log "Something went wrong while trying to autosave..."
      )
    ), timer)
    return


  addUnloadHandler = (form) ->
    form.find("input, textarea").on("keyup", ->
      form.data "unsaved-changes", true
    )

    $(".save").click(->
      form.data "unsaved-changes", false
    )

    $(window).on "beforeunload", ->
      "You haven't saved your changes."  if form.data "unsaved-changes"