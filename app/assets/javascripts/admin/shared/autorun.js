$(document).ajaxStart(function(){
  $("#progress").slideDown();
});
$(document).ajaxStop(function(){
  $("#progress").slideUp();
});

$(function(){
  $('.date-picker').datepicker({
    format: 'yyyy-mm-dd'
  });

  $('.flash').purr({
    fadeInSpeed: 500,
    fadeOutSpeed: 2000,
    removeTimer: 10000
  });


});
