class Storytime.Dashboard.Memberships
  initIndex: () ->
    $(".chosen").chosen
      width: "100%"

    $(document).on "ajax:success", ".new_membership", (e, data, status, xhr) ->
      $("#storytime-modal .modal-content").html(data.html)
      $(".chosen").chosen
        width: "100%"