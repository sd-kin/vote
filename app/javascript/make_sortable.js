$(document).on('turbolinks:load', function() {
  $('.sortable').sortable();
  $('#make-choice-button').click(makeChoice)

  randomizeOptionsList();
});

function makeChoice(){
  const pollId       = $('#options').data('poll-id');
  const choicesArray = $('.sortable').sortable('toArray');

  $.post({url: '/polls/' + pollId + '/choose', data: { choices_array: choicesArray } });
};

function randomizeOptionsList() {
  const parent = $('.sortable');
  const divs   = parent.children();

  while (divs.length) { parent.append(divs.splice(Math.floor(Math.random() * divs.length), 1)[0]); }
};