$(document).on('turbolinks:load', function() {
  const userInputs = Array.from(document.querySelectorAll('.user-input input'));
  if(!userInputs) return;

  userInputs.forEach( input => animateUserInput(input));
});

function animateOnFocus() {
  this.closest('div.user-input').classList.add('user-input-active')
}

function animateOnBlur() {
  this.closest('div.user-input').classList.remove('user-input-active')
}

function animateUserInput(input){
  input.addEventListener('focus', animateOnFocus);
  input.addEventListener('blur',  animateOnBlur);
}
