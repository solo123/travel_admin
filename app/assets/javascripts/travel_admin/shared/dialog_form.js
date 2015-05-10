function submit_dialog_form(btn){
	var f = $(btn).closest('.modal').find('form');
	var op = f.find('input[name=op]');
	if (op.length>0) {
		op.val($(btn).text());
	}
	if (f.length>0) {
		f.submit();
	}
}

function submit_this_form(btn){
  $(btn).closest('form').submit();
}
function remove_modal(btn){
  $(btn).closest('.modal').modal('hide').remove();
}
