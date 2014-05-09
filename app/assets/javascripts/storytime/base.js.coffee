$ ()->
  controller = $("body").data("controller")
  action = $("body").data("action")
  
  if Storytime[controller]?
    instance = new Storytime[controller]()
    instance["init"]() if typeof(instance["init"]) == "function"
    instance["init#{action}"]() if typeof(instance["init#{action}"]) == "function"
    Storytime.instance = instance

  $(".wysiwyg").wysihtml5()

  $(document).on('ajax:beforeSend', '.btn-delete-resource', ()->
    $(@).attr("disabled", true)
  ).on('ajax:success', '.btn-delete-resource', ()->
    $("##{$(@).data('resource-type')}_#{$(@).data('resource-id')}").remove()
  ).on('ajax:error', '.btn-delete-resource', (e, data, d1, d2)->
    $(@).attr("disabled", false)
    alert("There was an error deleting your #{$(@).data('resource-type')}")
  )