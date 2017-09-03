$(() => {
  const lock_validation_and_application = () => {
    $('#verify_application_draft, #apply_application_draft').addClass('disabled');
    return $('.unsaved_application_changes_notice').removeClass('hidden');
  };

  $(".edit_application_draft input, .edit_application_draft select, .edit_application_draft textarea").bind("change", lock_validation_and_application);

  const input = $(".gender-form-field");
  const genders = input.data('genders-src');
  return input.autocomplete({source: genders});
});
