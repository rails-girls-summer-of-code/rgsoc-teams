$ ->
  lock_validation_and_application = ->
    $('#verify_application_draft, #apply_application_draft').addClass('disabled')
    $('.unsaved_application_changes_notice').removeClass('hidden')

  $(".edit_application_draft input, .edit_application_draft select, .edit_application_draft textarea").change ->
    lock_validation_and_application()

  input = $(".gender-form-field")
  genders = input.data 'genders-src'
  input.autocomplete source: genders
