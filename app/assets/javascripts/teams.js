$(document).ready(function() {
    $('#team-sources input[id^=team_sources_attributes]:radio').change(function() {
        var helpText,
            helpNode = $($(this).parents()[2]).find('.help-block');

        if (this.value === 'blog') {
            helpText = "<div class='alert alert-warning'>Sources of type <b>Blog</b> will " +
                       "periodically synchronise all its posts. If you want to add a single " +
                       "web page, please select the <b>Page</b> option.</div>";
        } else {
            helpText = "";
        }
        helpNode.html(helpText);
    });
});
