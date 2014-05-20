$ ()->
  controller = $("body").data("controller")
  action = $("body").data("action")

  controllerObj = Storytime.Utilities.controllerFromString(controller)
  
  if controllerObj?
    instance = new controllerObj()
    instance["init"]() if typeof(instance["init"]) == "function"
    instance["init#{action}"]() if typeof(instance["init#{action}"]) == "function"
    Storytime.instance = instance

  $(".flash").delay(2000).fadeOut()

  $(document).on('ajax:beforeSend', '.btn-delete-resource', ()->
    $(@).attr("disabled", true)
  ).on('ajax:success', '.btn-delete-resource', ()->
    $("##{$(@).data('resource-type')}_#{$(@).data('resource-id')}").remove()
  ).on('ajax:error', '.btn-delete-resource', (e, data, d1, d2)->
    $(@).attr("disabled", false)
    alert("There was an error deleting your #{$(@).data('resource-type')}")
  )