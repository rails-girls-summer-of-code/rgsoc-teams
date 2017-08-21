document.addEventListener("DOMContentLoaded", function() {
    var fileInput = document.getElementById('input-csv-file-upload');
    var button    = document.getElementById('submit-csv-file-upload');

    button.disabled = fileInput.value === '';

    fileInput.addEventListener('change', function(e) {
        button.disabled = e.target.value === '';
    });
});
