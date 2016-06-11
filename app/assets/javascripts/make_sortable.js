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

  var setCookie = function(cookie_name, poll_id)
    {
      var ec = new evercookie();
      ec.get(cookie_name, function(value) { if(value == null ) {value = '[]'};
                                            var cookie =  JSON.parse(value);
                                            cookie.push(poll_id);
                                            ec.set(cookie_name, JSON.stringify($.unique(cookie))); 
                                          });            
    };           
  
  makeChoise = function(){
               var poll_id=$('#options').data('poll-id');
               var choise_array =  $('.sortable').sortable('toArray');
               setCookie('voted_polls', poll_id);
               var ec = new evercookie();
               ec.get('voted_polls', function(value) 
               {
                  $.post({url: '/polls/'+poll_id+'/make_choise', data: { choise_array: choise_array, voted_polls: JSON.parse(value) } });
               });
               
                         };
                       
                       };



$(document).ready(ready);
$(document).on('page:load', ready);