class Storytime.Dashboard.Contenteditable
  init: () ->
    inst = @
    $(".contenteditable").each ->
      contenteditable = $(this)
      inst.bindToInput(contenteditable)

    $(".contenteditable")[0].focus()

  bindToInput: (contenteditable) ->
    input = $(contenteditable.data("input"))

    contenteditable.keyup ->
      text = contenteditable.text()
      input.val(text)