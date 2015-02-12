class Storytime.Dashboard.Snippets
  init: ()->
    (new Storytime.Dashboard.Wysiwyg()).init()

    $(document).on('ajax:success', '.edit-snippet-form', (e, data, status, xhr) ->
      unless $(e.target).hasClass("storytime-modal-trigger")
        $(".storytime-snippet-#{data.id} .snippet-content").html(data.content)
    )