function submit_dialog_form(btn){
   $(btn).parent().parent().find('form').submit();
}
function submit_this_form(btn){
  $(btn).closest('form').submit();
}
