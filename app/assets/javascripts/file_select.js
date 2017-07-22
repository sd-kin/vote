$(document).on('turbolinks:load', function() {
  const fileSelect = document.querySelector('.file-input input[type=file]');
  const dropZone = document.getElementById('dropzone');
  if(!fileSelect) return;

  fileSelect.addEventListener('change', showFiles);

  if(dropZone){
    dropZone.addEventListener('dragover', handleDragOver);
    dropZone.addEventListener('drop', setDropToInput);
  } 
});

function handleDragOver(e) {
  e.stopPropagation();
  e.preventDefault();
  e.dataTransfer.dropEffect = 'copy';
}

function showFiles(e){
  const fileSelect = document.querySelector('.file-input input[type=file]');
  const filesArray = Array.from(fileSelect.files);

  showFileNames(filesArray);
  showPictures(filesArray);
  showAvatar(filesArray);
}

function setDropToInput(e) {
  e.stopPropagation();
  e.preventDefault();

  const fileSelect = document.querySelector('.file-input input[type=file]');

  fileSelect.files = e.dataTransfer.files;;
}

function showAvatar(input) {
    var reader = new FileReader();

    reader.onload = function (e) {
      if ($('.avatar img')) $('.avatar img').attr('src', e.target.result);
    }

    reader.readAsDataURL(input[0]);
}

function showPictures(files){
  const imgDiv = document.querySelector('#comment-images');
  if(!imgDiv) return;

  imgDiv.innerHTML='';

  files.map( file => {
    var reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = renderImage();
  });  
}

function renderImage(){
  return function(e) {
          let span = document.createElement('span');
          span.innerHTML = ['<img class="img-thumbnail img-preview" src="', e.target.result,'" title="', 'test', '"/>'].join('');
          document.querySelector('#comment-images').insertBefore(span, null)
        }
}

function showFileNames(files){
  const fileLabel = document.querySelector('.file-input label');
  const fileNames = files.reduce((res, file) => res + ' ' + file.name, '');

  fileLabel.innerText = fileNames;
}