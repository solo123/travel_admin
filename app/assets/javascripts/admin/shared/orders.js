function rm_if_new_record(check_tag){
  if (check_tag.name == undefined){
    return;
  }
  var rid = check_tag.name.match(/\[(\d+)\]/);
  if (rid.length > 1 && parseInt(rid[1]) > 100 ){
    $(check_tag).closest('div.item-template').slideUp('slow', function(){
      $(this).remove();
    });
  }
}

function set_account_name(select_tag){
  $('#account_account_name').val($(select_tag).find('option:selected').text());
}

function recaculate_pay_cash(){
  var recv = parseFloat($('#recv_cash').val());
  var balance_before = parseFloat($('#tb_balance_before').text());
  var pay_amount = recv;
  var change = 0;
  if (pay_amount > balance_before){
    change = pay_amount - balance_before;
    pay_amount = balance_before;
  }
  var balance = balance_before - pay_amount;

  $('#tb_pay_amount').text(pay_amount.toFixed(2));
  $('#tb_balance').text(balance.toFixed(2));
  $('#tb_change').text(change.toFixed(2));
  $('#pay_cash_amount').val(pay_amount);
}
function recaculate_pay_credit_card(){
  var amount = parseFloat($('#pay_credit_card_amount').val());
  var balance_before = parseFloat($('#tb_balance_before').text());
  if (amount > balance_before || amount <= 0){
    $('#pcc_msg').text('Error: Invalid amount');
    $('#edit_payment_div').find('.btn-primary').prop('disabled', true);
  } else {
    $('#pcc_msg').text('');
    $('#edit_payment_div').find('.btn-primary').prop('disabled', false);

    var card_type = $('#pay_credit_card_card_type').val();
    var rate = 0;
    if (card_type.length > 0 && credit_card_rate.length>0){
      rate = get_rate(card_type);
      if (rate==0) rate = get_rate('default');
    }
    var fee = amount * rate / 100;
    var tot = amount + fee;
    var balance = balance_before - amount;
    $('#pay_credit_card_service_fee').val(fee);
    $('#pay_credit_card_total_amount').val(tot);
    $('#td_service_fee').text(fee.toFixed(2));
    $('#td_card_amount').text(tot.toFixed(2));
    $('#td_balance').text(balance.toFixed(2));
  }
}
function get_rate(card_type){
  var name_pos = credit_card_rate.indexOf(card_type);
  if (name_pos<0) return 0;
  var s_pos = credit_card_rate.indexOf('|', name_pos) + 1;
  var e_pos = credit_card_rate.indexOf('|', s_pos);
  var rate = parseFloat(credit_card_rate.substring(s_pos, e_pos));
  if (isNaN(rate)) rate = 0;
  return rate;
}

function recaculate_pay_check(){
  var amount = parseFloat($('#pay_check_amount').val());
  var balance_before = parseFloat($('#tb_balance_before').text());
  var balance = balance_before - amount;
  $('#tb_pay_amount').text(amount.toFixed(2));
  $('#tb_balance').text(balance.toFixed(2));
  if (amount > balance_before){
    $('#pcc_msg').text('Error: Invalid amount');
    $('#edit_payment_div').find('.btn-primary').prop('disabled', true);
  } else {
    $('#pcc_msg').text('');
    $('#edit_payment_div').find('.btn-primary').prop('disabled', false);
  }
}
