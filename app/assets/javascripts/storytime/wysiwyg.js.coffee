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
      codeMirror = CodeMirror.fromTextArea $(this).find(".codemirror")[0], codeMirrorOptions

      self.bindCodeMirror $(this), codeMirror
      self.bindMedium $(this), codeMirror
      self.bindCodeToggle $(this), codeMirror, mediumEditor
      self.bindActionPanel $(this), mediumEditor

  setupMedium: ->
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
      html = tidy_html5 $(this).html(), tidyOptions
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
        codemirror.refresh()
        if code.is(":visible")
          $(this).text("WYSIWYG")
          mediumEditor.deactivate()
          $("#storytime-modal").addClass("modal-wide")
        else
          $(this).text("HTML")
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