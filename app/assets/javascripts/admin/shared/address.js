var current_city_div = null;

function set_current_city_field(tag){
  current_city_div = $(tag).parent();
}

function set_return_city_id(city_id){
  $(current_city_div).find('.city_id').val(city_id);
  $.get(host_path + '/cities/' + city_id + '/get_detail', function(data){
    $(current_city_div).find('span').text(data);
  });
}

