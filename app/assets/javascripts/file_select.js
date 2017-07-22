$(document).on('turbolinks:load', function() {
  const fileSelect = document.querySelector('.file-input input[type=file]');
  const dropZone = document.getElementById('dropzone');
  if(!fileSelect) return;

  fileSelect.addEventListener('change', showFiles);

  if(dropZone){
    dropZone.addEventListener('dragover', handleDragOver);
    dropZone.addEventListener('drop', showFiles);
  }
});

function handleDragOver(e) {
  e.stopPropagation();
  e.preventDefault();
  e.dataTransfer.dropEffect = 'copy';
}

function showFiles(e){
  const fileSelect = document.querySelector('.file-input input[type=file]');
  // debugger;
  const filesArray = getFiles(e, fileSelect);

  showFileNames(filesArray);
  readURL(fileSelect);
}

function getFiles(e, input) {
  if('drop' == e.type ) { //if files was dragged and dropped
    e.stopPropagation();
    e.preventDefault();
    
    const files = e.dataTransfer.files;

    input.files = files;

    return Array.from(files);
  }
  else { // if files was selected trough file input
    return Array.from(input.files);
  }
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

function showFileNames(files){
  const fileLabel = document.querySelector('.file-input label');
  const fileNames = files.reduce((res, file) => res + ' ' + file.name, '');

  fileLabel.innerText = fileNames;
}