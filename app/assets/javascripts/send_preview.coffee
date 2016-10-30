root = exports ? this

root.sendPreview = ->
  sform = $($('[data-js="form-with-preview"]')[0].elements).not('input:hidden[name=_method]').serialize()
  $.ajax
    type: 'POST'
    url: $('#preview-tab').data 'ajax-path'
    data: sform
    success: (data) ->
      $('#preview-pane').html data
      
      return
  return
  