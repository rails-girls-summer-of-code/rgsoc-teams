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
  var sform=$('#new_project').serialize()
   
  $.ajax({
    type: "POST",
    url: "/projects/preview",
    data: sform,
    success: function(data)
    {
    
    $('#preview_pane').html(data);
    
    }
  });
}