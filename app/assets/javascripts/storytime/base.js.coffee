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

  $(".chosen").chosen()

  $(document).on('ajax:beforeSend', '.btn-delete-resource', ()->
    $(@).attr("disabled", true)
  ).on('ajax:success', '.btn-delete-resource', ()->
    $("##{$(@).data('resource-type')}_#{$(@).data('resource-id')}").remove()
  ).on('ajax:error', '.btn-delete-resource', (e, data, d1, d2)->
    $(@).attr("disabled", false)
    alert("There was an error deleting your #{$(@).data('resource-type')}")
  )

  $(".table-row-link").click ->
    url = $(this).data('url')
    document.location.href = url

  $(document).on('ajax:success', '.storytime-modal-trigger', (e, data, status, xhr)->
    $("#storytime-modal .modal-content").html(data.html)
    console.log "SHOWING MODAL"
    $("#storytime-modal").modal("show")
  )

  $(document).on('ajax:success', '.storytime-modal-form', (e, data, status, xhr)->
    unless $(e.target).hasClass("storytime-modal-trigger")
      $("#storytime-modal").modal("hide")
  ).on("ajax:error", ".storytime-modal-form", (e, xhr, status, error)->
    unless $(e.target).hasClass("storytime-modal-trigger")
      data = JSON.parse(xhr.responseText)
      $("#storytime-modal .modal-content").html(data.html)
  )