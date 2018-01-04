$(document).ready(function() {
    $('div[data-behaviour=source-kind-switch] input:radio').change(function() {
        var helpText = "",
            helpNode = $(this).parents('div[data-behaviour=source-kind-switch]').find('.help-block');

        if (this.value === 'blog') {
            helpText = "<div class='alert alert-warning'>Sources of type <b>Blog</b> will " +
                       "periodically synchronise all its posts. If you want to add a single " +
                       "web page, please select the <b>Page</b> option.</div>";
        }
        helpNode.html(helpText);
    });
});
