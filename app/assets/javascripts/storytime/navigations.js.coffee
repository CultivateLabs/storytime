class Storytime.Dashboard.Navigations
  initIndex: ()->
    $('.sortable').sortable
      axis: 'y'
      handle: '.fa-bars'
      update: ->
        $.post($(this).data('update-url'), $(this).sortable('serialize'))