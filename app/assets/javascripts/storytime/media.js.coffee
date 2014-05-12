class Storytime.Dashboard.Media
  initIndex: ()->
    @initUpload()

    $(document).on('ajax:success', '#media_gallery .pagination a', (e, data, status, xhr)->
      $("#media_gallery").html(data)
    )

  initUpload: ()->
    $('#media_file').fileupload({
      dataType: 'json',
      done: (e, data)->
        $("#media_gallery").prepend(data.result.html)
      
      progressall: (e, data)->
        progress = parseInt(data.loaded / data.total * 100, 10);
        $('#progress .progress-bar').css('width', progress + '%');
      
    }).prop('disabled', !$.support.fileInput).parent().addClass($.support.fileInput ? undefined : 'disabled');