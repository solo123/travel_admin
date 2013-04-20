$(function(){
  merge_shift_table();
});

function merge_shift_table(){
  $('.shifts_table td.shift').each(function(){
    var colspan = 1;
    while($(this).attr('tag') == $(this).next().attr('tag')){
      $(this).next().remove();
      colspan++;
    }
    if (colspan>1){
      $(this).prop('colspan', colspan);
      $(this).text($(this).attr('tag'));
    }
  });
  $('.shifts_table td.shift').click(function(){
    window.open($(this).attr('link'));
  });
}
function go_shift(){
  location.href = location.pathname + '?year=' + $('#input_year').val() + '&month=' + $('#input_month').val();
}
