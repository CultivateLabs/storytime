class Storytime.Dashboard.Media
  initIndex: ()->
    @initUpload()
    @initPagination()
    return

  initPagination: ()->
    $(document).on('ajax:success', '#media_gallery .pagination a', (e, data, status, xhr)->
      $("#media_gallery").html(data)
      return
    )
    return

  initUpload: ()->
    unless @uploadInitialized
      $('#media_file').fileupload({
        dataType: 'json',
        done: (e, data)->
          $("#media_gallery").prepend(data.result.html)
          return
        
        progressall: (e, data)->
          progress = parseInt(data.loaded / data.total * 100, 10);
          $('#progress .progress-bar').css('width', progress + '%');
          return
        
      }).prop('disabled', !$.support.fileInput).parent().addClass($.support.fileInput ? undefined : 'disabled');
      @uploadInitialized = true
      return
    return

  initInsert: ()->
    self = @
    $(document).on "click", ".insert-image-button", (e)->
      e.preventDefault()

      if self.selectingFeatured
        featured_media = $("#featured_media_id")
        featured_media.val $(@).data("media-id")

        if $("#featured_media_image").length > 0
          $("#featured_media_image").attr("src", $(@).data("thumb-url"))
        else
          $("#featured_media_container").html("<img id='featured_media_image' src='#{$(@).data("thumb-url")}' />")

        featured_media.parent().parent().find(".select_featured_image").hide()
        featured_media.parent().parent().find(".remove_featured_image").show()

        $("#insertMediaModal").modal("hide")
        return
      else if self.selectingSecondary
        secondary_media = $("#secondary_media_id")
        secondary_media.val $(@).data("media-id")

        if $("#secondary_media_image").length > 0
          $("#secondary_media_image").attr("src", $(@).data("thumb-url"))
        else
          $("#secondary_media_container").html("<img id='secondary_media_image' src='#{$(@).data("thumb-url")}' />")

        secondary_media.parent().parent().find(".select_featured_image").hide()
        secondary_media.parent().parent().find(".remove_featured_image").show()

        $("#insertMediaModal").modal("hide")
        return
      else
        image_tag = "<img src='#{$(@).data("image-url")}' />"
        node = $(".summernote").data("range").createContextualFragment(image_tag)

        $(".summernote").data("range").insertNode(node)
        $(".note-image-dialog").modal("hide")
        return

    $(document).on "click", "button.remove_featured_image", (e) ->
      e.preventDefault()
      
      $(this).parent().find("input").val ""
      $(this).parent().find(".image_container").html ""

      $(this).parent().find(".select_featured_image").show()
      $(this).parent().find(".remove_featured_image").hide()
      return
    return

  initFeaturedImageSelector: ()->
    self = @
    $(document).on "click", "#featured_media_button", (e)->
      e.preventDefault()

      self.selectingFeatured = true
      self.selectingSecondary = false
      $("#insertMediaModal").modal("show")
      return

    $(document).on 'hidden.bs.modal', ()->
      self.selectingFeatured = false
      self.selectingSecondary = false
      return

    return
    
  initSecondaryImageSelector: ()->
    self = @
    $(document).on "click", "#secondary_media_button", (e)->
      e.preventDefault()

      self.selectingFeatured = false
      self.selectingSecondary = true
      $("#insertMediaModal").modal("show")
      return

    $(document).on 'hidden.bs.modal', ()->
      self.selectingFeatured = false
      self.selectingSecondary = false
      return

    return