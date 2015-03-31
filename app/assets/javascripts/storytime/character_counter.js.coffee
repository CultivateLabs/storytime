class Storytime.Dashboard.CharacterCounter
  init: ()->
    self = @
    $(".character-limit").each () ->
      display = $(this).find(".character-limit-display")
      limit = display.data("limit")
      input = $(this).find(".character-limit-input")
      contenteditable = $(this).find(".character-limit-contenteditable")
      self.setText(display, limit, input)

      if contenteditable.length > 0
        self.bind(contenteditable, input, display, limit)
      else
        self.bind(input, input, display, limit)

  setText: (display, limit, input) ->
    display.html limit - input.val().length

  bind: (field, input, display, limit) ->
    field.keypress((e) ->
      e.preventDefault() if (e.which is 32 or e.which > 0x20) and (input.val().length > limit - 1)
      return
    ).keyup(->
      display.html limit - input.val().length
      return
    )