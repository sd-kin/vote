$(document).on('turbolinks:load', function() {
  initializePollForm();
});

function initializePollForm(){
  if(!$('.poll_form')[0]) return;

  const dateFormat = 'YYYY/MM/DD HH:mm'
  const today      = moment();
  const tomorrow   = moment(today).add(1, 'days');
  const hourAfter  = moment(today).add(1, 'hours');


  initializeVotersLimitButton();
  initializeExpirationDateButton();

  $('#poll-expiration-date-input').datetimepicker(
    {format: dateFormat, defaultDate: tomorrow, minDate: hourAfter, showClear: true}
  ).on('dp.change', preventEmptyDate);
}

function preventEmptyDate(e) {
  if(e.date) return;

  const datetimepicker = $('#poll-expiration-date-input').data("DateTimePicker");
  const dateFormat     = datetimepicker.format()
  const defaultDate    = datetimepicker.defaultDate().format(dateFormat);

  e.target.querySelector('input').value = defaultDate;
  datetimepicker.hide();
  toggleExpirationForm(e.target);
}

function initializeVotersLimitButton() {
  const button       = document.querySelector('#poll-voters-limit-btn');
  const limitForm    = document.querySelector('#voters-limit-input');
  const cancelButton = limitForm.querySelector('#cancel-voters-limit-input')

  if(!button) return;

  button.addEventListener('click', () => toggleLimitForm(limitForm));
  cancelButton.addEventListener('click', ()=> hideLimitForm(limitForm));
}

function initializeExpirationDateButton() {
  const button            = document.querySelector('#poll-expiration-date-btn');
  const expirationForm    = document.querySelector('#poll-expiration-date-input');

  if(!button) return;

  button.addEventListener('click', () => toggleExpirationForm(expirationForm));
}

function toggleLimitForm(limitForm) {
  const hidden = limitForm.classList.contains('hide');

  if(hidden){
	  limitForm.classList.remove('hide');
  }
  else {
    limitForm.classList.add('hide');
  }
}

function hideLimitForm(limitForm) {
	const input = limitForm.querySelector('input');

	input.value = 'Infinity';
  limitForm.classList.add('hide');
}

function toggleExpirationForm(expirationForm) {
  const hidden = expirationForm.classList.contains('hide');

  if(hidden){
    expirationForm.classList.remove('hide');
    $('#poll-expiration-date-input').data("DateTimePicker").show(); // show datetimepicker
  }
  else {
    expirationForm.classList.add('hide');
  }
}
