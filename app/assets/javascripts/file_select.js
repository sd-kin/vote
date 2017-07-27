$(document).on('turbolinks:load', function() {
  const formsWithImageUpload = document.querySelectorAll('.form-with-image-upload');

  if(formsWithImageUpload.length < 1) return;

  formsWithImageUpload.forEach( form => initializeFormWithImages(form));
});

function initializeFormWithImages(form) {
  const fileButton = form.querySelector('.file-input');
  const fileInput  = form.querySelector('input[type=file]');
  const dropZone   = form.querySelector('textarea');
  const fileLabel  = form.querySelector('.file-input label');
  const imagesDiv  = form.querySelector('.comment-images');

  fileButton.addEventListener('click', () => fileInput.click());
  fileInput.addEventListener('change', () => showFiles(fileInput, fileLabel, imagesDiv));

  if(dropZone){
    dropZone.addEventListener('dragover', handleDragOver);
    dropZone.addEventListener('drop', e => setDropToInput(e, fileInput));
  }
}

function handleDragOver(e) {
  e.stopPropagation();
  e.preventDefault();
  e.dataTransfer.dropEffect = 'copy';
}

function showFiles(fileSelect, fileLabel, imagesDiv){
  const filesArray = Array.from(fileSelect.files);

  showFileNames(filesArray, fileLabel);
  showPictures(filesArray, imagesDiv);
  showAvatar(filesArray);
}

function setDropToInput(e, fileSelect) {
  e.stopPropagation();
  e.preventDefault();

  fileSelect.files = e.dataTransfer.files;;
}

function showAvatar(input) {
    var reader = new FileReader();

    reader.onload = function (e) {
      if ($('.avatar img')) $('.avatar img').attr('src', e.target.result);
    }

    reader.readAsDataURL(input[0]);
}

function showPictures(files, imgDiv){
  if(!imgDiv) return;

  imgDiv.innerHTML='';

  files.map( file => {
    var reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = renderImage(imgDiv);
  });
}

function renderImage(imgDiv){
  return function(e) {
          let span = document.createElement('span');
          span.innerHTML = ['<img class="img-thumbnail img-preview" src="', e.target.result,'" title="', 'test', '"/>'].join('');
          imgDiv.insertBefore(span, null)
        }
}

function showFileNames(files, label){
  label.innerText = files.reduce((res, file) => res + ' ' + file.name, '');
}