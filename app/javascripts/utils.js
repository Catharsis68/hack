var moment = require('moment');

var now = moment();

function fillTable(stock) {
  for (i = 0; i < stock.length; i++) {
      var tr = document.createElement('TR');
      for (j = 0; j < stock[i].length; j++) {
          var td = document.createElement('TD')
          td.appendChild(document.createTextNode(stock[i][j]));
          tr.appendChild(td)
      }
      tableBody.appendChild(tr);
  }
}



module.exports = {
  now,
  fillTable
}
