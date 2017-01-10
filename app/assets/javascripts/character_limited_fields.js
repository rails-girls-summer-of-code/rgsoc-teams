$(function() {
    $('[data-behaviour="character-limited"]').each(function() {
        $(this).on("keyup", characterCounter);
        $(this).trigger("keyup");
    });

    function characterCounter() {
        var $field = $(this);
        var $countParagraph = $field.next();
        var $count = $countParagraph.children('.character_limited_counter');

        var maxlength      = parseInt($field.data('maxlength'));
        var remainingChars = maxlength - $field.val().length;

        if (remainingChars < 0) {
            if (!$countParagraph.hasClass('character_limit_exceeded')) {
                $countParagraph.addClass('character_limit_exceeded');
            }
        } else {
            $countParagraph.removeClass('character_limit_exceeded');
        }

        $count.html(remainingChars);
    }

});
