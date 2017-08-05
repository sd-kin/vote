$(document).on('turbolinks:load', function() {
  initializeUserInput();
});

function initializeUserInput(){
  const inputNodes = document.querySelectorAll('.user-input input');
  if(inputNodes.length<1) return;
  const userInputs = Array.from(inputNodes);

  userInputs.forEach( function(input) {animateUserInput(input)} );
}

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
