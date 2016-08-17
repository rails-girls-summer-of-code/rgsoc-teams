// send_preview = ->
//   sform = $('#new_project').serialize()
//   $.ajax
//     type: 'POST'
//     url: '/projects/preview'
//     data: sform
//     success: (data) ->
//       $('#preview_pane').html data
//       return
//   return

  function send_preview() {
  var sform=$($('[data-js="project_form"]')[0].elements).not('input:hidden[name=_method]').serialize()
  $.ajax({
    type: "POST",
    url: "/projects/preview",
    data: sform,
    success: function(data)
    {
    
    $('#preview_pane').html(data);

    console.log(data);
    
    }
  });
}