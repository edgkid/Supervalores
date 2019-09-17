function setInvoiceVsReceiptLineChart(elementID, labels, invoiceData, receiptData) {
  var lineData = {
    // labels: ["Enero","Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"],
    labels: labels,
    datasets: [
      {
        label: "Recibos Pagados",
        backgroundColor: 'rgba(26,179,148,0.5)',
        borderColor: "rgba(26,179,148,0.7)",
        pointBackgroundColor: "rgba(26,179,148,1)",
        pointBorderColor: "#fff",
        // data: [28, 48, 40, 19, 86, 27]
        data: receiptData
      },{
        label: "Facturas",
        backgroundColor: 'rgba(220, 220, 220, 0.5)',
        pointBorderColor: "#fff",
        // data: [65, 59, 80, 81, 56, 55]
        data: invoiceData
      }
    ]
  };

  var lineOptions = {
    responsive: true
  };

  var ctx = document.getElementById(elementID).getContext("2d");
  new Chart(ctx, {type: 'line', data: lineData, options:lineOptions});
}

function setMonthlyIncomeFlotChart(elementID) {
  var d1 = [[1262304000000, 6], [1264982400000, 3057], [1267401600000, 20434], [1270080000000, 31982], [1272672000000, 26602], [1275350400000, 27826], [1277942400000, 24302], [1280620800000, 24237], [1283299200000, 21004], [1285891200000, 12144], [1288569600000, 10577], [1291161600000, 10295]];
  var d2 = [[1262304000000, 5], [1264982400000, 200], [1267401600000, 1605], [1270080000000, 6129], [1272672000000, 11643], [1275350400000, 19055], [1277942400000, 30062], [1280620800000, 39197], [1283299200000, 37000], [1285891200000, 27000], [1288569600000, 21000], [1291161600000, 17000]];

  var data1 = [
    { label: "Data 1", data: d1, color: '#999999'},
    { label: "Data 2", data: d2, color: '#008080' }
                  ];
  $.plot($(elementID), data1, {
    xaxis: {
      tickDecimals: 0
    },
    series: {
      lines: {
        show: true,
        fill: true,
        fillColor: {
          colors: [{
            opacity: 1
          }, {
            opacity: 1
          }]
        },
      },
      points: {
        width: 0.1,
        show: false
      },
    },
    grid: {
      show: false,
      borderWidth: 0
    },
    legend: {
      show: false,
    }
  });
}