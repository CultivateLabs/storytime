$ ()->
  controller = $("body").data("controller")
  action = $("body").data("action")

  controllerObj = Storytime.Utilities.controllerFromString(controller)
  
  if controllerObj?
    instance = new controllerObj()
    instance["init"]() if typeof(instance["init"]) == "function"
    instance["init#{action}"]() if typeof(instance["init#{action}"]) == "function"
    Storytime.instance = instance

  $(".wysiwyg").wysihtml5
    html: true
    color: true
    customTemplates:
      "html": (locale, options)->
        size = if (options && options.size) then ' btn-'+options.size else ''
        return "<li>" +
            "<div class='btn-group'>" +
            "<a class='btn btn-" + size + " btn-default' data-wysihtml5-action='change_view' title='" + locale.html.edit + "' tabindex='-1'><i class='glyphicon glyphicon-pencil'></i>&nbsp;&nbsp;Raw HTML Mode</a>" +
            "</div>" +
            "</li>"

  $(document).on('ajax:beforeSend', '.btn-delete-resource', ()->
    $(@).attr("disabled", true)
  ).on('ajax:success', '.btn-delete-resource', ()->
    $("##{$(@).data('resource-type')}_#{$(@).data('resource-id')}").remove()
  ).on('ajax:error', '.btn-delete-resource', (e, data, d1, d2)->
    $(@).attr("disabled", false)
    alert("There was an error deleting your #{$(@).data('resource-type')}")
  )