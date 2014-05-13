class Storytime.Dashboard.Media
  initIndex: ()->
    @initUpload()
    @initPagination()

  initPagination: ()->
    $(document).on('ajax:success', '#media_gallery .pagination a', (e, data, status, xhr)->
      $("#media_gallery").html(data)
    )

  initUpload: ()->
    unless @uploadInitialized
      $('#media_file').fileupload({
        dataType: 'json',
        done: (e, data)->
          $("#media_gallery").prepend(data.result.html)
        
        progressall: (e, data)->
          progress = parseInt(data.loaded / data.total * 100, 10);
          $('#progress .progress-bar').css('width', progress + '%');
        
      }).prop('disabled', !$.support.fileInput).parent().addClass($.support.fileInput ? undefined : 'disabled');
      @uploadInitialized = true

  initInsert: ()->
    $(document).on "click", ".insert-image-button", (e)->
      e.preventDefault()
      wysihtml5Editor = $("textarea.wysiwyg").data("wysihtml5").editor
      wysihtml5Editor.composer.commands.exec("insertImage", { src: $(@).data("image-url") })
      $("#insertMediaModal").modal("hide")
