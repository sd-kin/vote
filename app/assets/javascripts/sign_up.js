$(document).on('turbolinks:load', function() {
  const userInputs = Array.from(document.querySelectorAll('.user-input input'));
  if(!userInputs) return;

  userInputs.forEach( input => animateUserInput(input));
});

function animateOnFocus() {
  const wrappingDiv = this.closest('div.user-input')

  wrappingDiv.classList.remove('user-input-error')
  wrappingDiv.classList.add('user-input-active')
}

function animateOnBlur() {
  const wrappingDiv = this.closest('div.user-input')

  wrappingDiv.classList.remove('user-input-active')
  if(this.value.length == 0){wrappingDiv.classList.add('user-input-error')}
}

function animateUserInput(input){
  input.addEventListener('focus', animateOnFocus);
  input.addEventListener('blur',  animateOnBlur);
}
