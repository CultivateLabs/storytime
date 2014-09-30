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
    self = @
    $(document).on "click", ".insert-image-button", (e)->
      e.preventDefault()
      if self.selectingFeatured
        $("#featured_media_id").val $(@).data("media-id")
        if $("#featured_media_image").length > 0
          $("#featured_media_image").attr("src", $(@).data("thumb-url"))
        else
          $("#featured_media_container").html("<img id='featured_media_image' src='#{$(@).data("thumb-url")}' />")

        $("#insertMediaModal").modal("hide")

      else
        # TODO: Change out to insert image into Summernote editor.
        # wysihtml5Editor = $("textarea.wysiwyg").data("wysihtml5").editor
        # wysihtml5Editor.composer.commands.exec("insertImage", { src: $(@).data("image-url") })
        $("#insertMediaModal").modal("hide")

  initFeaturedImageSelector: ()->
    self = @
    $(document).on "click", "#featured_media_button", (e)->
      e.preventDefault()
      self.selectingFeatured = true
      $("#insertMediaModal").modal("show")

    $(document).on 'hidden.bs.modal', ()->
      self.selectingFeatured = false
