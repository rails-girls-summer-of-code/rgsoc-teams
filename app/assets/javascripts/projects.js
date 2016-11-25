$(function() {

    var input = $('#project_license');
    var src   = input.data('licenses-src');

    $.getJSON(src, function(licenses) {
        input.autocomplete({ source: licenses });
    });

});

