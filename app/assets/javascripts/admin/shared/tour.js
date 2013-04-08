function caculate_tour_price(){
  var price = parseFloat($('#tour_tour_price_attributes_price_adult').val());
  var single_charge = parseFloat($('#tour_tour_price_attributes_single_charge').val());
  var forth_charge = parseFloat($('#tour_tour_price_attributes_forth_charge').val());
  if (price>0 && single_charge>0 && forth_charge>0) {
  var price1 = price + single_charge;
  var price2 = price + price;
  var price3 = price2;
  var price4 = price2 + forth_charge;

  $('#tour_tour_price_attributes_price1').val(price1);
  $('#tour_tour_price_attributes_price2').val(price2);
  $('#tour_tour_price_attributes_price3').val(price3);
  $('#tour_tour_price_attributes_price4').val(price4);
  } else {
    alert("Price setting maybe error!");
  }
}
function caculate_tour_price_rev(){
  var price1 = parseFloat($('#tour_tour_price_attributes_price1').val());
  var price2 = parseFloat($('#tour_tour_price_attributes_price2').val());
  var price3 = parseFloat($('#tour_tour_price_attributes_price3').val());
  var price4 = parseFloat($('#tour_tour_price_attributes_price4').val());
  if (price1>0 && price2>=price1 && price3>=price2 && price4>=price3){
    var price = price2 / 2;
    var single_charge = price1 - price;
    var forth_charge = price4 - price2;

    $('#tour_tour_price_attributes_price_adult').val(price);
    $('#tour_tour_price_attributes_single_charge').val(single_charge);
    $('#tour_tour_price_attributes_forth_charge').val(forth_charge);
  } else {
    alert('price1 ~ price4 maybe error!');
  }
}
