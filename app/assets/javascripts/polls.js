$(document).on('turbolinks:load', function() {
  initializeVotersLimitButton();
  initializeExpirationDateButton();

  $('#poll-expiration-date-input').datetimepicker();
});

function initializeVotersLimitButton() {
  const button       = document.querySelector('#poll-voters-limit-btn');
  const limitForm    = document.querySelector('#voters-limit-input');
  const cancelButton = limitForm.querySelector('#cancel-voters-limit-input')

  if(!button) return;

  button.addEventListener('click', () => showLimitForm(limitForm));
  cancelButton.addEventListener('click', ()=> hideLimitForm(limitForm));
}

function initializeExpirationDateButton() {
  const button            = document.querySelector('#poll-expiration-date-btn');
  const expirationForm    = document.querySelector('#poll-expiration-date-input');
  const cancelButton      = expirationForm.querySelector('#cancel-expiration-date-input')

  if(!button) return;

  button.addEventListener('click', () => showExpirationForm(expirationForm));
  cancelButton.addEventListener('click', ()=> hideExpirationForm(expirationForm));
}

function showLimitForm(limitForm) {
	limitForm.classList.remove('hide');
}

function hideLimitForm(limitForm) {
	const input = limitForm.querySelector('input');

	limitForm.classList.add('hide');
	input.value = 'Infinity';
}

function showExpirationForm(expirationForm) {
	expirationForm.classList.remove('hide');
}

function hideExpirationForm(expirationForm) {
	expirationForm.classList.add('hide');
}
