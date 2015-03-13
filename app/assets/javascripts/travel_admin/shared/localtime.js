$.localtime.setFormat("MMM,dd hh:mm");
function to_localtime(){
  $('time.local-datetime').each(function(){
    $(this).text($.localtime.toLocalTime($(this).attr('datetime'), "MMM,dd hh:mm"));
  });
  $('time.local-date').each(function(){
    $(this).text($.localtime.toLocalTime($(this).attr('datetime'), "MMM,dd yyyy"));
  });
}

$(function(){
  to_localtime();
});
