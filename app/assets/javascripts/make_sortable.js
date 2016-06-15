var ready = function() {
            $('.sortable').hover(function() {
                                 $(this).css('cursor','move');
                                            });

  $(function () {
    var parent = $('.sortable');
    var divs = parent.children();
    while (divs.length) { parent.append(divs.splice(Math.floor(Math.random() * divs.length), 1)[0]); }
                });

  $('.sortable').sortable();
                  
  makeChoise = function(){
               var poll_id=$('#options').data('poll-id');
               var choise_array =  $('.sortable').sortable('toArray');
               $.post({url: '/polls/'+poll_id+'/make_choise', data: { choise_array: choise_array } });
                         };
                       
                       };



$(document).ready(ready);
$(document).on('page:load', ready);