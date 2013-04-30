$(document).ajaxStart(function(){
  $("#progress").slideDown();
});
$(document).ajaxStop(function(){
  $("#progress").slideUp();
});

$(function(){
  $('.flash').purr({
    fadeInSpeed: 500,
    fadeOutSpeed: 2000,
    removeTimer: 10000
  });

  $('.barcode').barcode($('.barcode').text(), 'code128', {barHeight:20});
  $('.date-picker').datepicker({
    format: 'yyyy-mm-dd'
  });

});
