var find_user_global_timeout = null;

function find_user(){
  var str = $('#user_find').val();
  if (str.length <= 2 ){
    $('#search_result').html('');
    if (find_user_global_timeout !=null) clearTimeout(find_user_global_timeout);
  } else {
    if (find_user_global_timeout !=null) clearTimeout(find_user_global_timeout);
    find_user_global_timeout = setTimeout(search_user, 1000);
  }

}
function search_user(){
  find_user_global_timeout = null;
  $('#search_result').html('<tr><td colspan=5>Loading...</td></tr>');
  $.get(host_path + '/user_infos/search?q=' + $('#user_find').val(), function(data){
    $('#search_result').html(data);
    $('#search_result tr').click(function(){
      alert($(this).attr('tag'));
      $.get(host_path + '/user_infos/' + $(this).attr('tag') + '/edit');
    });
  });
}
