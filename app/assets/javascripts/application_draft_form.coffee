$ ->
  lock_validation_and_application = ->
    $('#verify_application_draft, #apply_application_draft').prop( "disabled", true )
    $('.unsaved_application_changes_notice').removeClass('hidden')

  $(".edit_application_draft input, .edit_application_draft select, .edit_application_draft textarea").change ->
    lock_validation_and_application()
