$(document).ready(function() {
    var joinProjectLink = $('#joinProjectLink');
            if (joinProjectLink) {
                joinProjectLink.click( function() {
                    $('#joinProjectLink').hide();
                    $('#want-to-help').slideDown(200);
                });
            }
});



