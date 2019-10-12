function calculatePendingPayment(invoiceTotal, amountPaid, target) {
  target.val((invoiceTotal - amountPaid).toFixedDown(2));
}

function showOrHideCheckNumber(paymentMethodSelectId) {
  if (($(paymentMethodSelectId).find("option:selected").text()).toLowerCase() === 'cheque') {
    $('#num-cheque-container').show();
  } else {
    $('#num-cheque-container').hide();
  }
}