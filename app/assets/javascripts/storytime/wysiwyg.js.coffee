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
    # TODO: FIGURE OUT A WAY TO GET RID OF ALL THIS DUPLICATION
    mediumEditor = new MediumEditor('#medium-editor-post', mediumEditorOptions)
    mediumEditor2 = new MediumEditor('#medium-editor-snippet', mediumEditorOptions)

    if $("#post_draft_content").length > 0
      codeMirror = CodeMirror.fromTextArea $("#post_draft_content")[0], codeMirrorOptions

    if $("#snippet_content").length > 0
      codeMirror2 = CodeMirror.fromTextArea $("#snippet_content")[0], codeMirrorOptions

    if codeMirror
      codeMirror.on "change", () ->
        if $("#wysiwyg-post .CodeMirror").is(":visible")
          code = codeMirror.getValue()
          $('#medium-editor-post').html(code)
          $($('#medium-editor-post').data('input')).val(code)

    if codeMirror2
      codeMirror2.on "change", () ->
        if $("#wysiwyg-snippet .CodeMirror").is(":visible")
          code = codeMirror2.getValue()
          $('#medium-editor-snippet').html(code)
          $($('#medium-editor-snippet').data('input')).val(code)

    $('#medium-editor-post').on 'input', () ->
      input = $($(this).data('input'))
      html = tidy_html5 $(this).html(), tidyOptions
      input.val(html)
      codeMirror.setValue(html)

    $('#medium-editor-snippet').on 'input', () ->
      input = $($(this).data('input'))
      html = tidy_html5 $(this).html(), tidyOptions
      input.val(html)
      codeMirror2.setValue(html)

    $("[data-toggle='codemirror']").on "click", () ->
      editor = $($(this).data('target'))
      wysywyg = $(this).closest('.wysiwyg').find(".CodeMirror")
      editor.toggle()
      wysywyg.toggle()
      if codeMirror
        codeMirror.refresh()
      if codeMirror2
        codeMirror2.refresh()
      if wysywyg.is(":visible")
        $(this).text("WYSIWYG")
        # SCOPE
        mediumEditor.deactivate()
        mediumEditor2.deactivate()
      else
        # SCOPE
        $(this).text("HTML")
        mediumEditor.activate()
        mediumEditor2.activate()

    $(".post-action-panel").on "show.bs.collapse", ->
      $("[data-toggle='codemirror']").hide()

    $(".post-action-panel").on "hide.bs.collapse", ->
      $("[data-toggle='codemirror']").show()

    $(".post-action-panel").on "show.bs.collapse", ->
      mediumEditor.activate()
      $("#editor").show()
      $(".CodeMirror").hide()