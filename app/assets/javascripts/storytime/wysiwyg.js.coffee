class Storytime.Dashboard.Wysiwyg
  mediumEditorOptions = 
    buttons: ['bold', 'italic', 'underline', 'anchor', 'header1', 'header2', 'quote', 'unorderedlist', 'orderedlist', 'pre']
    toolbarAlign: 'center'
    buttonLabels: 'fontawesome'

  codeMirrorOptions = 
    mode: 'htmlmixed'
    theme: 'solarized dark'
    tabSize: 2
    autoCloseTags: true
    lineNumbers: true

  tidyOptions = 
    "indent": "auto",
    "indent-spaces": 2,
    "wrap": 80,
    "markup": true,
    "output-xml": false,
    "numeric-entities": true,
    "quote-marks": true,
    "quote-nbsp": false,
    "show-body-only": true,
    "quote-ampersand": false,
    "break-before-br": true,
    "uppercase-tags": false,
    "uppercase-attributes": false,
    "drop-font-tags": true,
    "tidy-mark": false

  init: () ->
    self = @
    self.bindTogglesToPanels()
    mediumEditor = self.setupMedium()

    $(".wysiwyg").each () ->
      unless $(this).find(".CodeMirror").length > 0
        codeMirror = CodeMirror.fromTextArea $(this).find(".codemirror")[0], codeMirrorOptions

      self.bindCodeMirror $(this), codeMirror
      self.bindMedium $(this), codeMirror
      self.bindCodeToggle $(this), codeMirror, mediumEditor
      self.bindActionPanel $(this), mediumEditor

    $("[data-toggle='codemirror']").click ->
      self.closeImageControls()
      mediumEditor.activate()

    $("body").click (e) ->
      target = $(e.target)
      if !target.is(".medium-editor img") && !target.hasClass("medium-image-controls") && !(target.closest(".medium-image-controls").length > 0) && $('.medium-image-controls').is(":visible")
        self.closeImageControls()
        mediumEditor.activate()

    $("body").on 'click', '.medium-editor img', (e) ->
      active = $(this).hasClass("medium-active-image")
      unless active
        $(".medium-editor img").removeClass("medium-active-image")
        $(this).addClass "medium-active-image"
        $("#medium-image-width").val($(this)[0].style.width)
        $("#medium-image-height").val($(this)[0].style.height)
        $("#medium-image-button").hide()
        $(".medium-image-controls").show()
        mediumEditor.deactivate()

    $('body').on "keyup", "#medium-image-width", () ->
      if $(this).val() == "" || $(this).val() == "auto"
        $(".medium-active-image").css("width", "")
        $("#medium-image-height").val("")
        $("#medium-image-width").val("")
      else
        $(".medium-active-image").css("width", $(this).val())
        $(".medium-active-image").css("height", "")
        $("#medium-image-height").val($(".medium-active-image").css("height"))

    $('body').on "keyup", "#medium-image-height", () ->
      # set the height, then find the new width and set that and remove the height so image remains responsive
      $(".medium-active-image").css("width", "")
      $(".medium-active-image").css("height", $(this).val())
      newWidth = $(".medium-active-image").css("width")
      $("#medium-image-width").val(newWidth)
      $(".medium-active-image").css("width", newWidth)
      $(".medium-active-image").css("height", "")

    $('body').on "click", ".medium-image-float", () ->
      direction = $(this).data("float")
      image = $(".medium-active-image")
      switch direction
        when "left" then image.removeClass("pull-right pull-left").addClass("pull-left")
        when "right" then image.removeClass("pull-right pull-left").addClass("pull-right")
        when "none" then image.removeClass("pull-right pull-left")

    $('body').on "click", ".medium-image-delete", () ->
      image = $(".medium-active-image")
      image.remove()
      self.updateFromMediumEditor()
      self.closeImageControls()
      mediumEditor.activate()

  openImageControls: (image) ->
    console.log image
    image.addClass("medium-active-image")
    $("#medium-image-width").val(image[0].style.width)
    $("#medium-image-height").val(image[0].style.height)
    $("#medium-image-button").hide()
    $(".medium-image-controls").show()

  closeImageControls: ->
    $(".medium-editor img").removeClass("medium-active-image")
    $("#medium-image-button").show()
    $(".medium-image-controls").hide()
    @updateFromMediumEditor()

  updateFromMediumEditor: ->
    $('.medium-editor').each ->
      input = $($(this).data('input'))
      codemirror = input.siblings('.CodeMirror')[0].CodeMirror
      html = $(this).html()
      input.val(html)
      codemirror.setValue(html)

  setupMedium: ->
    # Medium-editor keeps adding toolbars when this method gets triggered 
    # (i.e. when opening snippets modal on post edit page) and they all seem 
    # to get activated at the same time, so this clears out existing ones first
    $('.medium-editor-toolbar').remove()
    $('.medium-editor-anchor-preview').remove()
    mediumEditor = new MediumEditor('.medium-editor', mediumEditorOptions)
    mediumEditor

  bindCodeMirror: (wysiwyg, codemirror) ->
    codemirror.on "change", () ->
      if wysiwyg.find(".CodeMirror").is(":visible")
        code = codemirror.getValue()
        wysiwyg.find(".medium-editor").html(code)
        $(wysiwyg.find(".medium-editor").data('input')).val(code)

  bindMedium: (wysiwyg, codemirror) ->
    wysiwyg.find('.medium-editor').on 'input', () ->
      input = $($(this).data('input'))
      # html = tidy_html5 $(this).html(), tidyOptions
      html = $(this).html()
      input.val(html)
      codemirror.setValue(html)

  bindCodeToggle: (wysiwyg, codemirror, mediumEditor) ->
    toggle = wysiwyg.find("[data-toggle='codemirror']")
    unless toggle.hasClass "bound"
      toggle.addClass("bound")
      wysiwyg.on "click", "[data-toggle='codemirror']", () ->
        editor = wysiwyg.find('.editor')
        code = wysiwyg.find('.CodeMirror')
        editor.toggle()
        code.toggle()

        html = tidy_html5 wysiwyg.find('.medium-editor').html(), tidyOptions
        codemirror.setValue(html)

        codemirror.refresh()
        if code.is(":visible")
          $(this).children("i").removeClass("fa-code").addClass("fa-font")
          mediumEditor.deactivate()
          $("#storytime-modal").addClass("modal-wide")
        else
          $(this).children("i").removeClass("fa-font").addClass("fa-code")
          mediumEditor.activate()
          $("#storytime-modal").removeClass("modal-wide")

    $("#storytime-modal").on 'hide.bs.modal', ->
      $(this).removeClass "modal-wide"

  bindActionPanel: (wysiwyg, mediumEditor) ->
    $(".post-action-panel").on "show.bs.collapse", ->
      mediumEditor.activate()
      wysiwyg.find('.editor').show()
      wysiwyg.find('.CodeMirror').hide()
  
  bindTogglesToPanels: () ->
    $(".post-action-panel").on "show.bs.collapse", ->
      $("[data-toggle='codemirror']").hide()

    $(".post-action-panel").on "hide.bs.collapse", ->
      $("[data-toggle='codemirror']").show()