$(function() {
    $('[data-behaviour="character-limited"]').each(function() {
        $(this).on("keyup", characterCounter);
    });

    function characterCounter() {
        var $field = $(this);
        var maxlength = parseInt($field.attr("maxlength"));
        var remainingChars = maxlength - $field.val().length;
        console.log(remainingChars);
    }

});
