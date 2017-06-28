$(document).keyup(function(event) {
    if ($("#some_inputs").is(":focus") && (event.keyCode == 13)) {
        $("#some_button").click();
    }
});

