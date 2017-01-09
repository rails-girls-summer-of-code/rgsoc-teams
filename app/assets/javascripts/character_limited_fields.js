$(function() {
    $('[data-behaviour="character-limited"]').each(function() {
        $(this).on("keyup", characterCounter);
    });

    function characterCounter() {
        var $field = $(this);
        var $count = $field.next().children(".character_limited_counter");

        var maxlength      = parseInt($field.attr("maxlength"));
        var remainingChars = maxlength - $field.val().length;

        $count.html(remainingChars);
    }

});
