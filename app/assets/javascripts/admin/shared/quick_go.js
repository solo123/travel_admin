function quick_go_enter(sender) 
{
    if(window.event && window.event.keyCode == 13) 
    {
        if (sender!=null)
        {
            if(sender.id=="qg_order") quick_go_order();
            if(sender.id=="qg_schedule") quick_go_schedule();
            if(sender.id=="qg_tour" ) quick_go_tour();
        }
        return false; 
    } else
        return true;
}

function quick_go(url, id_tag){
  var id = parseInt($(id_tag).val());
  if (id > 0){
    location = url + "/" + id;
  } else {
    $(id_tag).focus();
  }
}
function quick_go_tour(){
  quick_go('tours', '#qg_tour');
}
function quick_go_schedule(){
  quick_go('schedules', '#qg_schedule');
}
function quick_go_order(){
  quick_go('orders', '#qg_order');
}

