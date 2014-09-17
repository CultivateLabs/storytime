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

    $('.wysihtml5-sandbox').contents().find('body').focus(->
      console.log "Load thingy"
      updateLater(10000)
      
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