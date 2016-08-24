root = exports ? this

root.sendPreview = ->
  sform = $($('[data-js="project_form"]')[0].elements).not('input:hidden[name=_method]').serialize()
  $.ajax
    type: 'POST'
    url: $('#preview_tab').data 'ajax_path'
    data: sform
    success: (data) ->
      $('#preview_pane').html data
      
      return
  return
  