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

  editorDiv = "<div class='medium-image-controls' style='padding: 20px; background: #333; color: #fff;'>" +
                "<div class='container-fluid'>" +
                  "<div class='row'>" +
                    "<div class='col-md-6'>" +
                      "<input type='text' id='medium-image-width' placeholder='Width' class='form-control' />" +
                    "</div>" +
                    "<div class='col-md-6'>" +
                      "<input type='text' id='medium-image-height' placeholder='Height' class='form-control' />" +
                    "</div>" +
                  "</div>" +
                "</div>" +
              "</div>" 

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

    $("[data-toggle='codemirror']").click ->
      self.closeImageControls()
      mediumEditor.activate()

    $("body").click (e) ->
      target = $(e.target)

      if !target.hasClass("medium-image-controls") && !(target.closest(".medium-image-controls").length > 0)
        self.closeImageControls()
        mediumEditor.activate()
      if target.is("img") && !target.hasClass("medium-active-image")
        self.openImageControls(target)
        mediumEditor.deactivate()

    $('body').on "keyup", "#medium-image-width", () ->
      newWidth = parseFloat($(this).val())
      $(".medium-active-image").css("width", newWidth)
      $(".medium-active-image").css("height", "")
      $("#medium-image-height").val($(".medium-active-image").css("height"))

    $('body').on "keyup", "#medium-image-height", () ->
      # set the height, then find the new width and set that and remove the height so image remains responsive
      newHeight = parseFloat($(this).val())
      $(".medium-active-image").css("width", "")
      $(".medium-active-image").css("height", newHeight)
      newWidth = $(".medium-active-image").css("width")
      $("#medium-image-width").val(newWidth)
      $(".medium-active-image").css("width", newWidth)
      $(".medium-active-image").css("height", "")

  openImageControls: (image) ->
    image.before(editorDiv)
    image.addClass("medium-active-image")
    $("#medium-image-width").val(image.css("width"))
    $("#medium-image-height").val(image.css("height"))

  closeImageControls: ->
    $(".medium-editor img").removeClass("medium-active-image")
    $(".medium-image-controls").remove()

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
          # $(this).text("WYSIWYG")
          mediumEditor.deactivate()
          $("#storytime-modal").addClass("modal-wide")
        else
          # $(this).text("HTML")
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