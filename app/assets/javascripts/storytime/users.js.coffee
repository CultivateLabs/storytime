class Storytime.Dashboard.Users
  initIndex: () ->
    $(".chosen").chosen
      width: '100%'

    $(document).on "ajax:success", ".new_membership", (e, data, status, xhr) ->
      console.log data.html
      $("#storytime-modal .modal-content").html(data.html)
      $(".chosen").chosen
        width: '100%'