function date_to_string(date){
  var m = date.getMonth() + 1;
  var d = date.getDate();
  return date.getFullYear() + '.' + (m<10?'0'+m:m) + '.' + (d<10?'0'+d:d);
}
