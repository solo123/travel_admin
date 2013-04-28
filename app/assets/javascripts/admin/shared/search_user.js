var find_user_global_timeout = null;
var find_agent_global_timeout = null;

function find_user(){
  var str = $('#user_find').val();
  if (str.length < 2 ){
    $('#list_result_user_infos tr').remove();
    if (find_user_global_timeout !=null) clearTimeout(find_user_global_timeout);
  } else {
    if (find_user_global_timeout !=null) clearTimeout(find_user_global_timeout);
    find_user_global_timeout = setTimeout(search_user, 1000);
  }

}
function search_user(){
  find_user_global_timeout = null;
  $('#list_result_user_infos tr').remove();
  $.get(host_path + '/user_infos/search?q=' + $('#user_find').val(), function(data){
    $('#list_result_user_infos tr').remove();
    $('#list_result_user_infos').append(data);
    $('#list_result_user_infos tr').click(function(){
      $.get(host_path + '/user_infos/' + $(this).attr('tag') + '/edit');
    });
  });
}
function goto_find_user(){
  var user_name = $('#order_order_detail_attributes_full_name').val();
  $.getScript(host_path + '/user_infos/find?n=' + user_name);
}

function find_agent(){
  var str = $('#agent_find').val();
  if (str.length < 2 ){
    $('#list_result_agents tr').remove();
    if (find_agent_global_timeout !=null) clearTimeout(find_agent_global_timeout);
  } else {
    if (find_agent_global_timeout !=null) clearTimeout(find_agent_global_timeout);
    find_agent_global_timeout = setTimeout(search_agent, 1000);
  }

}
function search_agent(){
  find_agent_global_timeout = null;
  $('#list_result_agents tr').remove();
  $('#list_result_agents').append('<tr><td colspan=5>Loading...</td></tr>');
  $.get(host_path + '/companies/search_agent?q=' + $('#agent_find').val(), function(data){
    $('#list_result_agents tr').remove();
    $('#list_result_agents').append(data);
    $('#list_result_agents tr').click(function(){
      $.get(host_path + '/companies/' + $(this).attr('tag') + '/edit');
    });
  });
}
function goto_find_agent(){
  //var user_name = $('#order_order_detail_attributes_full_name').val();
  $.getScript(host_path + '/companies/find_agent');
}
