var gen_schedules_cancle_processing = false;
function generate_schedules(){
	var t = $(".gen-new:first");
	if (gen_schedules_cancle_processing || t.length < 1 ) {
		$('#gen_schedules_operate_box').hide();
		return;
	}
	t.removeClass('gen-new').addClass('gen-current')
		.parent().addClass('do-current').animate({backgroundColor:'#f4b4b4'},1000);
	var ids = t.next().next().find('ul li').map(function(){return $(this).text();}).get().join(',');
	$('body').animate({scrollTop: t.offset().top-160}, 1000);
	
	$.get(host_path + '/schedules/generate',{tour: t.text(), ids: ids}, function(data){
		var t = $(".gen-current:first");
		t.text(data).removeClass('gen-current')
			.parent().removeClass('do-current').addClass('do-done').animate({backgroundColor:'#90ee90'},500);
		generate_schedules();
	});
}
function start_generate_schedules(){
	gen_schedules_cancle_processing=false;
	$('#gen_schedules_operate_box').show();
	generate_schedules();
}
function gen_schedules_cancle_operate(){
	gen_schedules_cancle_processing=true;
	$('#gen_schedules_operate_box').hide();
}

