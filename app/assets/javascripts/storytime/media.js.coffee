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
          lastRow = $("#media_gallery").children(".row").last()
          if lastRow.children(".col-sm-3").length == 5
            $("#media_gallery").append("<div class='row'>#{data.result.html}</div>")
          else
            lastRow.append(data.result.html)
          $("#progress").hide()
          return
        
        progressall: (e, data)->
          progress = parseInt(data.loaded / data.total * 100, 10)
          $("#progress").show()
          $('#progress .progress-bar').css('width', progress + '%')
          return
        
      }).prop('disabled', !$.support.fileInput).parent().addClass($.support.fileInput ? undefined : 'disabled')
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

        featured_media.parent().parent().addClass("has-image")

        $("#insertMediaModal").modal("hide")
        return
      else if self.selectingSecondary
        secondary_media = $("#secondary_media_id")
        secondary_media.val $(@).data("media-id")

        if $("#secondary_media_image").length > 0
          $("#secondary_media_image").attr("src", $(@).data("thumb-url"))
        else
          $("#secondary_media_container").html("<img id='secondary_media_image' src='#{$(@).data("thumb-url")}' />")

        secondary_media.parent().parent().addClass("has-image")

        $("#insertMediaModal").modal("hide")
        return
      else if self.selectingSecondary
        $("#secondary_media_id").val $(@).data("media-id")
        if $("#secondary_media_image").length > 0
          $("#secondary_media_image").attr("src", $(@).data("thumb-url"))
        else
          $("#secondary_media_container").html("<img id='secondary_media_image' src='#{$(@).data("thumb-url")}' />")

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

      $(this).parent().removeClass("has-image")
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