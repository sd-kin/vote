var ready = function() {
  $('.sortable').hover(function() {
        $(this).css('cursor','move');
                                  });

  $('.sortable').sortable();
                       };

$(document).ready(ready);
$(document).on('page:load', ready);