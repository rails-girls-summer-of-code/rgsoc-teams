$(function() {
    var fieldsCount,
        maxFieldsCount = 2,
        $addLink = $('a.add_nested_fields');

    function toggleAddLink() {
        $addLink.toggle(fieldsCount <= maxFieldsCount);
    }

    $(document).on('nested:fieldAdded:attendances', function() {
        fieldsCount += 1;
        toggleAddLink();
    });

    $(document).on('nested:fieldRemoved:attendances', function() {
        fieldsCount -= 1;
        toggleAddLink();
    });

    // count existing nested fields after page was loaded
    fieldsCount = $('form .fields').length;
    toggleAddLink();
});