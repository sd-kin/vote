var ready = function() {
  $('.sortable').hover(function() {
        $(this).css('cursor','move');
                                  });

  $(function () {
    var parent = $('.sortable');
    var divs = parent.children();
    while (divs.length) {
        parent.append(divs.splice(Math.floor(Math.random() * divs.length), 1)[0]);
    }
  });

  $('.sortable').sortable();
                       };

$(document).ready(ready);
$(document).on('page:load', ready);