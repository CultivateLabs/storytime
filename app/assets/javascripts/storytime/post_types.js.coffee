class Storytime.Dashboard.PostTypes
  initForm: ()->
    $(document).on 'click', 'form .remove_fields', (event) ->
      $(this).prev('input[type=hidden]').val('1')
      $(this).closest('fieldset').hide()
      event.preventDefault()

    $(document).on 'click', 'form .add_fields', (event) ->
      time = new Date().getTime()
      regexp = new RegExp($(this).data('id'), 'g')
      $(this).before($(this).data('fields').replace(regexp, time))
      event.preventDefault()

  initNew: ()->
    @initForm()

  initEdit: ()->
    @initForm()