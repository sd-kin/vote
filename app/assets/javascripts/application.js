// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.remotipart
//= require jquery-ui
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree .

document.addEventListener("DOMContentLoaded",function(){
  const fileSelect = document.querySelector('.file-input input[type=file]');

  fileSelect.addEventListener('change', showFileName);
});

function showFileName(){
  const fileLabel = document.querySelector('.file-input .file-label');
  const fileName  = this.value.split(/(\\|\/)/g).pop() || 'no file choosen';

  fileLabel.innerText=fileName
}
