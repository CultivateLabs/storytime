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