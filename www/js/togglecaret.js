Shiny.addCustomMessageHandler("togglecaret",
                              function(message) {
                                var el = document.getElementById(message.id);
                                if ($(el).hasClass('fa-caret-down')) {
                                  if (message.val) 
                                    $(el).removeClass('fa-caret-down').addClass('fa-filter');
                                  else 
                                    $(el).removeClass('fa-caret-down').addClass('fa-caret-right');
                                }
                                else 
                                  if ($(el).hasClass('fa-filter')) {
                                    $(el).removeClass('fa-filter').addClass('fa-caret-down');
                                  }
                                else
                                  if ($(el).hasClass('fa-caret-right')) {
                                    $(el).removeClass('fa-caret-right').addClass('fa-caret-down');
                                  }
                              }
);