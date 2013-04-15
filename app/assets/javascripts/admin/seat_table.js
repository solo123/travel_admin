// button commands
function hold(){
	if (validate_seats()){
		var msg = prompt("Please input hold message:", "");
    if (msg) {
      var pane = $('form.edit_schedule_assignment');
      pane.find('input[name=message1]').val(msg);
      pane.find('input[name=operate]').val('hold');
      $('form.edit_schedule_assignment').submit();
    }
	}	
}
function check_hold(hold_id){
  var cbs = 'input[type=checkbox][hold_id=' + hold_id + ']';
  $(cbs).prop('checked', !$(cbs).prop('checked'));
}
function release(){
	if (validate_hold_seats()) {
		if (confirm('Are you sure to RELEASE these seats?')){
      var pane = $('form.edit_schedule_assignment');
			pane.find('input[name=operate]').val('release');
      $('form.edit_schedule_assignment').submit();
		}
	}
}
function order(){
  if (validate_order_seats()){
    $.ajax({
      type: "GET",
      url: host_path + "/orders/new",
      dataType: 'script',
      data: 'assignment_id=' + $('#assignment_id').val() + '&seats=' + get_selected_seats()
    });
  }
}

function order_after_created(){
 order_after_updated();
}
function reload_orders(){
  $.get(host_path + "/schedules/"+ $('.s-id').text().trim() +"/orders",function(data){
    $('#unseat_orders').html(data);
  });
}
function get_selected_seats(){
	var pane = $('.seat-table');
	var ss = pane.find('input[type="checkbox"]:checked').map(function(){return this.id.substring(3);}).get().join(',');
	return ss;
}

function validate_seats(){
  var pane = $('.seat-table');
	if (pane.find('input[type="checkbox"]:checked').length == 0){
		alert('Please select seats.');
		return false;
	}

	var result = '';
	pane.find('input[type="checkbox"]:checked').each(function(){ 
    var seat = $(this).closest('.seat');
    if(!seat.hasClass('blnk')) result += $(this).parent().text().trim() + ', '; 
  });
	if (result.length > 0) {
		alert('Seats: ' + result + 'been taken. Please check again.');
		return false;
	}

	return true;
}
function validate_hold_seats(){
	var pane = $('.seat-table');
	if (pane.find('input[type="checkbox"]:checked').length == 0){
		alert('Please select hold seats.');
		return false;
	}

	var result = '';
	pane.find('input[type="checkbox"]:checked').each(function(){
    var seat = $(this).closest('.seat');
    if(!seat.hasClass('hold') && !seat.hasClass('sold')) result += $(this).parent().text().trim() + ', '; 
  });
	if (result.length > 0) {
		alert('Seats: ' + result + ' not hold. Please check again.');
		return false;
	}
	return true;
}

function validate_order_seats(){
  var pane = $('.seat-table');
	if (pane.find('input[type="checkbox"]:checked').length == 0){
		alert('Please select seats.');
		return false;
	}

	var result = '';
	pane.find('input[type="checkbox"]:checked').each(function(){
    var seat = $(this).closest('.seat');
    if(seat.hasClass('sold')) result += $(this).parent().text().trim() + ', '; 
  });
	if (result.length > 0) {
		alert('Seats: ' + result + ' already been order. \n\nPlease check again.');
		return false;
	}

	return true;
}

function assign_seat(order_id){
  if (validate_seats()){
	  var pane = $('.seat-table');
    pane.find('input[name=order_id]').val(order_id);
    pane.find('input[name=operate]').val('order_seats');
    pane.find('form').submit();
  }
}
function set_order_customer(uid){
  $("#edit_user_info_div").modal('hide');
  $('#search_user_div').modal('hide');

  $('#order_order_detail_attributes_user_info_id').val(uid);
  if (uid > 0 ){
    $.getJSON(host_path + '/user_infos/' + uid, function(data){
      $('#order_order_detail_attributes_full_name').val(data.full_name);
      $('#order_order_detail_attributes_telephone').val(data.telephone);
      $('#order_order_detail_attributes_email').val(data.email);
      $('#order_order_detail_attributes_bill_address').val(data.address);
      //test = data;
    });
  } else {
    $('#order_order_detail_attributes_full_name').val("");
    $('#order_order_detail_attributes_telephone').val("");
    $('#order_order_detail_attributes_email').val("");
    $('#order_order_detail_attributes_bill_address').val("");
  }
}
var order_room_template = 
"<tr><td><input name='order[order_items_attributes][000][num_adult]' size='2' type='text' value=''></td>" +
"<td><input name='order[order_items_attributes][000][num_child]' size='2' type='text' value=''></td>" +
"<td>amount:</td><td><a href='javascript:void(0)' class='delete_room'>Remove</a></td></tr>";

function add_room(){
  var new_id = new Date().getTime();
  var regexp = new RegExp("000", "g");
  $("#rooms")
    .append(order_room_template.replace(regexp, new_id));

  $('.delete_room').click(function(){
    $(this).parent().parent().remove();
  });
}

function bind_driver_selection(){
  var opt_driver = $('#schedule_assignment_driver_id').prop('options');
  var opt_driver_ass = $('#schedule_assignment_driver_assistance_id').prop('options');
  opt_driver[0] = new Option('', '');
  opt_driver_ass[0] = new Option('', '');
  for(var i=0; i<driver_list.length; i++){
    opt_driver[opt_driver.length] = new Option(driver_list[i][0], driver_list[i][1]);
    opt_driver_ass[opt_driver_ass.length] = new Option(driver_list[i][0], driver_list[i][1]);
  }
}

function bind_tourguide_selection(){
  var opt_tg = $('#schedule_assignment_tour_guide_id').prop('options');
  var opt_tg_ass = $('#schedule_assignment_tour_guide_assistance_id').prop('options');
  opt_tg[0] = new Option('', '');
  opt_tg_ass[0] = new Option('', '');
  for(var i=0; i<tourguide_list.length; i++){
    opt_tg[opt_tg.length] = new Option(tourguide_list[i][0], tourguide_list[i][1]);
    opt_tg_ass[opt_tg_ass.length] = new Option(tourguide_list[i][0], tourguide_list[i][1]);
  }
}



