$(document).on('turbolinks:load', function() {
  initializeUserInput();
});

function initializeUserInput(){
  const inputNodes = document.querySelectorAll('.user-input input');
  const inputCount = inputNodes.length
  if(inputCount < 1) return;

  for(var i = 0; i < inputCount; i++) {animateUserInput(inputNodes[i])};
}

function animateOnFocus() {
  const wrappingDiv = this.parentNode

  wrappingDiv.classList.remove('user-input-error')
  wrappingDiv.classList.add('user-input-active')
}

function animateOnBlur() {
  const wrappingDiv = this.parentNode

  wrappingDiv.classList.remove('user-input-active')
  if(this.value.length == 0){wrappingDiv.classList.add('user-input-error')}
}

function animateUserInput(input){
  input.addEventListener('focus', animateOnFocus);
  input.addEventListener('blur',  animateOnBlur);
}
