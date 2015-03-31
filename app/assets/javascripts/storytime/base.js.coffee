initJS = (controller, action) ->
  controllerObj = Storytime.Utilities.controllerFromString(controller)
  if controllerObj?
    instance = new controllerObj()
    instance["init"]() if typeof(instance["init"]) == "function"
    instance["init#{action}"]() if typeof(instance["init#{action}"]) == "function"
    Storytime.instance = instance

$ ()->
  initJS($("body").data("controller"), $("body").data("action"))

  $(".flash").delay(4000).fadeOut() unless window.Storytime.test_env

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

  $(document).on "click", ".storytime-menu-toggle", (e) ->
    e.preventDefault()
    $("#storytime-main-menu").toggle()
    $("#storytime-sites-menu").toggle()

  $(document).on('ajax:success', '.storytime-modal-trigger, #storytime-modal .pagination a', (e, data, status, xhr)->
    $("#storytime-modal .modal-content").html(data.html)
    $("#storytime-modal").removeClass("modal-wide")
    initJS($("#storytime-modal-controller").val(), $("#storytime-modal-action").val())
    $("#storytime-modal").modal("show")
  )

  $(document).on('ajax:success', '.storytime-modal-form', (e, data, status, xhr)->
    unless $(e.target).hasClass("storytime-modal-trigger")
      if $(this).data("redirect") == "index"
        $("#storytime-modal").removeClass("modal-wide")
        $("#storytime-modal .modal-content").html(data.html)
        if $("#storytime-modal-controller").length && $("#storytime-modal-action").length
          initJS($("#storytime-modal-controller").val(), $("#storytime-modal-action").val())

      $('body').append("<div class='flash js-flash'><div class='flash-success'>Your changes were saved successfully</div></div>")
      
      $('.chosen').chosen
        width: '100%'
      
      $(".js-flash").show().delay(4000).fadeOut '300', ->
        $(this).remove()

  ).on("ajax:error", ".storytime-modal-form", (e, xhr, status, error)->
    unless $(e.target).hasClass("storytime-modal-trigger")
      data = JSON.parse(xhr.responseText)
      $("#storytime-modal .modal-content").html(data.html)
      initJS($("#storytime-modal-controller").val(), $("#storytime-modal-action").val())
  )