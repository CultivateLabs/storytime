class Storytime.Dashboard.Tags
  init: () ->
    # Add new tags
    $(".tags-input").each ->
      tagsInput = $(this)
      searchInput = tagsInput.next("div").find(".search-field").children("input")
      searchInput.on 'keyup', (e) ->
        if e.which is 13 and searchInput.val().length > 0
          searched_tag = searchInput.val()
          tagsInput.append('<option value="nv__' + searched_tag + '">' + searched_tag + '</option>')

          selected_tags = tagsInput.val() || []
          selected_tags.push "nv__#{searched_tag}"

          tagsInput.val selected_tags
          tagsInput.trigger 'chosen:updated'
        return