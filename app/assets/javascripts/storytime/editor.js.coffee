class Storytime.Dashboard.Editor
  init: ()->
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
      $("#preview_post").click(->
        saveForm()
      )

      if $("#main").data("preview")
        $("#preview_post").trigger("click")
        window.open $("#preview_post").attr("href")
    else
      $("#preview_new_post").click(->
        $("<input name='preview' type='hidden' value='true'>").insertAfter($(".new_post").children().first())
        $(".new_post").submit()
      )

    $('.wysihtml5-sandbox').contents().find('body').focus(->
      updateLater(10000) if $(".edit_post").length
      
      $('.wysihtml5-sandbox').contents().find('body').off('focus')
    )

  updateLater = (timer) ->
    timer = 120000  unless timer?
    timeoutId = window.setTimeout((->
      saveForm()
    ), timer)
    return

  saveForm = () ->
    data = []
    data.push {name: "id", value: $("#main").data("post-id")}
    data.push {name: "post[draft_content]", value: $(".edit_post").last().find("#post_draft_content").val()}

    $.ajax(
      type: "POST"
      url: "/dashboard/autosaves"
      data: data
    ).done(->
      updateLater(10000)
    ).fail(->
      console.log "Something went wrong while trying to autosave..."
    )