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
        done: (e, data)->
          $("#media_gallery_container").html(data.result)
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
      else
        image_tag = "<img src='#{$(@).data("image-url")}' class='img-responsive' />"
        if self.elementContainsSelection($("#medium-editor-post")[0])
          self.pasteHtmlAtCaret(image_tag, false)
        else
          $("#medium-editor-post").append(image_tag)
          
        input = $($("#medium-editor-post").data("input"))
        html = $("#medium-editor-post").html()
        input.val(html)
        codemirror = input.siblings(".CodeMirror")[0].CodeMirror
        codemirror.setValue(html)
        $("#insertMediaModal").modal("hide")
        return

    $(document).on "click", "button.remove_featured_image", (e) ->
      e.preventDefault()
      
      $(this).parent().find("input").val ""
      $(this).parent().find(".image_container").html ""

      $(this).parent().removeClass("has-image")
      return
    return

  initImageSelector: () ->
    self = @
    $(document).on "click", ".insert-media-button", (e) ->
      e.preventDefault()
      $("#insertMediaModal").modal("show")
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

  pasteHtmlAtCaret: (html, selectPastedContent) ->
    self = @
    sel = undefined
    range = undefined
    if window.getSelection
      # IE9 and non-IE
      sel = window.getSelection()
      if sel.getRangeAt and sel.rangeCount
        range = sel.getRangeAt(0)
        range.deleteContents()
        # Range.createContextualFragment() would be useful here but is
        # only relatively recently standardized and is not supported in
        # some browsers (IE9, for one)
        el = document.createElement('div')
        el.innerHTML = html
        frag = document.createDocumentFragment()
        node = undefined
        lastNode = undefined
        while node = el.firstChild
          lastNode = frag.appendChild(node)
        firstNode = frag.firstChild
        range.insertNode frag
        # Preserve the selection
        if lastNode
          range = range.cloneRange()
          range.setStartAfter lastNode
          if selectPastedContent
            range.setStartBefore firstNode
          else
            range.collapse true
          sel.removeAllRanges()
          sel.addRange range
    else if (sel = document.selection) and sel.type != 'Control'
      # IE < 9
      originalRange = sel.createRange()
      originalRange.collapse true
      sel.createRange().pasteHTML html
      if selectPastedContent
        range = sel.createRange()
        range.setEndPoint 'StartToStart', originalRange
        range.select()
    return

  isOrContains: (node, container) ->
    while node
      if node == container
        return true
      node = node.parentNode
    false

  elementContainsSelection: (el) ->
    self = @
    sel = undefined
    if window.getSelection
      sel = window.getSelection()
      if sel.rangeCount > 0
        i = 0
        while i < sel.rangeCount
          if !self.isOrContains(sel.getRangeAt(i).commonAncestorContainer, el)
            return false
          ++i
        return true
    else if (sel = document.selection) and sel.type != 'Control'
      return self.isOrContains(sel.createRange().parentElement(), el)
    false