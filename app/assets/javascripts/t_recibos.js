function calculatePendingPayment(invoiceTotal, amountPaid, target) {
  target.val(invoiceTotal - amountPaid);
}
