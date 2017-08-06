$(document).on('turbolinks:load', function() {
  const formsWithImageUpload = document.querySelectorAll('.form-with-image-upload');
  const formsCount = formsWithImageUpload.length;

  if(formsCount < 1) return;

  for(var i=0; i<formsCount; i++) { initializeFormWithImages(formsWithImageUpload[i]) };
});

function initializeFormWithImages(form) {
  const fileButton = form.querySelector('.file-input');
  const fileInput  = form.querySelector('input[type=file]');
  const dropZone   = form.querySelector('.dropzone');
  const fileLabel  = form.querySelector('.file-input label');
  const imagesDiv  = form.querySelector('.attached-images');

  fileButton.addEventListener('click', function(){ fileInput.click() });
  fileInput.addEventListener('change', function(){ showFiles(fileInput, fileLabel, imagesDiv) });

  if(dropZone){
    dropZone.addEventListener('dragover', handleDragOver);
    dropZone.addEventListener('drop', function(e){ setDropToInput(e, fileInput) });
  }
}

function handleDragOver(e) {
  e.stopPropagation();
  e.preventDefault();
  e.dataTransfer.dropEffect = 'copy';
}

function showFiles(fileSelect, fileLabel, imagesDiv){
  var filesArray = [];
  var nodes = fileSelect.files;

  for(var i = nodes.length; i--; filesArray.unshift(nodes[i]));

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

  files.map( function(file){
    var reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = renderImage(imgDiv);
  });
}

function renderImage(imgDiv){
  return function(e) {
          var span = document.createElement('span');
          span.innerHTML = ['<img class="img-thumbnail img-preview" src="', e.target.result,'" title="', 'test', '"/>'].join('');
          imgDiv.insertBefore(span, null)
        }
}

function showFileNames(files, label){
  label.innerText = files.reduce( function(res, file){ return res+file.name+' '}, '')
}