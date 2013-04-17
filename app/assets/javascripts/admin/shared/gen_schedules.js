var gen_schedules_cancle_processing = false;
function generate_schedules(){
  var t = $('#list_tours tbody input[type=checkbox]:checked:first').closest('tr');
  if (t.length>0){
    $('#auto_gen_indicator').slideDown('slow').find('input[type=checkbox]').prop('checked', true);
  	$('body').animate({scrollTop: t.offset().top-160}, 1000);
    t.find('a:last').click();
  } else {
    $('#auto_gen_indicator:visible').slideUp('slow');
  }
}
function hotline_tr(btn){
  $(btn).closest('tr').addClass('hotline');
}
function stop_auto_gen(){
  $('#auto_gen_indicator').slideUp('slow');
}
