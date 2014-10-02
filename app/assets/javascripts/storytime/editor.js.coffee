class Storytime.Dashboard.Editor
  init: ()->
    mediaInstance = new Storytime.Dashboard.Media()
    mediaInstance.initPagination()
    mediaInstance.initInsert()
    mediaInstance.initFeaturedImageSelector()

    $(document).on 'shown.bs.modal', ()->
      mediaInstance.initUpload()
      return

    # Title character limit
    title_character_limit = $("#title_character_limit").data("limit")
    $("#title_character_limit").html title_character_limit - $("#post_title").val().length

    $("#post_title").keypress((e) ->
      e.preventDefault() if (e.which is 32 or e.which > 0x20) and ($("#post_title").val().length > title_character_limit - 1)
      return
    ).keyup(->
      $("#title_character_limit").html title_character_limit - $("#post_title").val().length
      return
    )

    # Excerpt character limit
    excerpt_character_limit = $("#excerpt_character_limit").data("limit")
    $("#excerpt_character_limit").html excerpt_character_limit - $("#post_excerpt").val().length

    $("#post_excerpt").keypress((e) ->
      e.preventDefault() if (e.which is 32 or e.which > 0x20) and ($("#post_excerpt").val().length > excerpt_character_limit - 1)
      return
    ).keyup(->
      $("#excerpt_character_limit").html excerpt_character_limit - $("#post_excerpt").val().length
      return
    )

    # Summernote config and setup
    $(".summernote").summernote
      height: 300
      minHeight: null
      maxHeight: null
      toolbar: [
        ['style', ['style']]
        ['font', ['bold', 'italic', 'underline', 'superscript', 'subscript', 'strikethrough', 'clear']]
        # ['fontname', ['fontname']]
        # ['fontsize', ['fontsize']]
        ['color', ['color']]
        ['para', ['ul', 'ol', 'paragraph']]
        # ['height', ['height']]
        ['table', ['table']]
        ['insert', ['link', 'picture', 'video', 'hr']]
        ['view', ['fullscreen', 'codeview']]
        ['editing', ['undo', 'redo']]
        ['help', ['help']]
      ]

      onblur: ->
        $(".summernote").data("range", document.getSelection().getRangeAt(0))
        return

      onImageUpload: (files, editor, $editable) ->
        $("#media_file").fileupload('send', {files: files})
          .success((result, textStatus, jqXHR) ->
            editor.insertImage($editable, result.file_url)
            return
          )
        return

    $(".note-image-dialog").on 'shown.bs.modal', () ->
      $(".note-image-dialog").find(".row-fluid").append(
        "<div id='gallery_copy'>
          <h5>Gallery</h5>
          <div id='media_gallery'>" + 
            $("#media_gallery").html() + 
          "</div>
        </div>")
      return

    $(".note-image-dialog").on 'hide.bs.modal', () ->
      $("#gallery_copy").remove()
      return

    return