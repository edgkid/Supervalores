// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require activestorage
//= require turbolinks
//= require jquery-2.1.1.js
//= require jquery-3.1.1.min.js
//= require rails-ujs
//= require popper
//= require bootstrap.js
//= require vendor/jquery-ui/jquery-ui.min.js
//= require vendor/dataTables/datatables.min.js
//= require vendor/dataTables/dataTables.bootstrap4.min.js
//= require vendor/typehead/bootstrap3-typeahead.min.js
//= require vendor/select2/select2.full.min.js
//= require vendor/datapicker/bootstrap-datepicker.js
//= require vendor/chartJs/Chart.min.js
//= require_tree .

Number.prototype.toFixedDown = function(digits) {
  var re = new RegExp("(\\d+\\.\\d{" + digits + "})(\\d)"),
      m = this.toString().match(re);
  return m ? parseFloat(m[1]) : this.valueOf();
};

function allowOnlyNumbers(thys) {
  var value = thys.value;
  console.log(value);
  $(thys).val(value.replace(/[^\d.\-]+/, ''));
}
