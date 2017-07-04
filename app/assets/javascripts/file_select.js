$(document).on('turbolinks:load', function() {
  const fileSelect = document.querySelector('.file-input input[type=file]');
  if(!fileSelect) return;

  fileSelect.addEventListener('change', showFile);
});

function showFile(){
  const fileLabel = document.querySelector('.file-input label');
  const fileName  = this.value.split(/(\\|\/)/g).pop() || 'no file choosen';
  const fileSelect = document.querySelector('.file-input input[type=file]');

  fileLabel.innerText=fileName
  readURL(fileSelect)
}

function readURL(input) {
  if (input.files && input.files[0]) {
    var reader = new FileReader();

    reader.onload = function (e) {
      $('form img').attr('src', e.target.result);
    }

    reader.readAsDataURL(input.files[0]);
  }
}