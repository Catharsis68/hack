// Import the page's CSS. Webpack will know what to do with it.
import "../stylesheets/app.css";
var { now } = require('./utils.js');

// Import libraries we need.
import { default as Web3} from 'web3';
import { default as contract } from 'truffle-contract'

// Import our contract artifacts and turn them into usable abstractions.
import tdm_artifacts from '../../build/contracts/TimeDeliveryManagement.json'

var TimeDeliveryManagement = contract(tdm_artifacts);

var accounts;
var account;


window.App = {
  start: function() {
    var self = this;

    document.getElementById('datePicker').valueAsDate = new Date();

    // Bootstrapping TimeDeliveryManagement
    TimeDeliveryManagement.setProvider(web3.currentProvider);

    // Get the initial account balance so it can be displayed.
    TimeDeliveryManagement.web3.eth.getAccounts(function(err, accs) {
      if (err != null) {
        alert("There was an error fetching your accounts.");
        return;
      }

      if (accs.length == 0) {
        alert("Couldn't get any accounts! Make sure your Ethereum client is configured correctly.");
        return;
      }

      accounts = accs;
      account = accounts[0];

    TimeDeliveryManagement.web3.eth.defaultAccount = account;
      var defaultAccount = TimeDeliveryManagement.web3.eth.defaultAccount;
      // console.log('defaultAccount ', defaultAccount); // ''
      // console.log('account', account);

      // self.getAllDeliverySlots();
      // self.createDeliverySlot();
      // self.createSupplier();
      // self.getAllDeliverySlots();
    });
  },

  /** list all delivery slots
   * @param {number} startTime as seconds
   * @param {number} endTime as seconds
   * @return {bytes} length 10
   */
  listDeliverySlots: function() {

    var timeFrom = now;
    var timeTo = now;

    console.log(`from: ${from} - to: ${to}`);
  },

  getAllDeliverySlots: function() {
    var tdm;

    TimeDeliveryManagement.deployed()
      .then(function(instance) {
        tdm = instance;

        // return tdm.createSupplier().send({from: account});
        console.log(tdm.contract);

        return tdm.getAllDeliverySlots.call(1, 1)
          .then(function(data) {
            console.log(`data: ${data}`);
          })
          .catch(function(e) {
            console.log(`error: ${e}`);
          });
      });
  },

  // function createSupplier(address fromAddress)  public returns (bool success)
  createSupplier: function() {
    var tdm;

    TimeDeliveryManagement.deployed()
      .then(function(instance) {
        tdm = instance;

        tdm.debug.call()
          .then(function(i) {
            console.log(`debug: ${i}`);
          });

        return tdm.createSupplier.call(account)
          .then(function(data) {
              console.log('data', data);
        });
      })
      .catch(function(error) {
        console.log(error);
      });
  },

  createDeliverySlot: function() {
    var tdm;

    TimeDeliveryManagement.deployed()
      .then(function(instance) {
        tdm = instance;

        // console.log('tdm', tdm);
        // API ref: myContract.methods.myMethod(123)
        // console.log('account ', account);
        let id = 111;
        let warehouseName = 'warehouseXV';
        let isTradeable = true;
        let from = 0;
        let to = 0;
        let price = 25;
        let gate = 'gateName';
        let deliveryType = 'food'

        tdm.warehouse.call()
          .then(function(item) {
            console.log('warehouse:', item);
          });

        tdm.debug.call()
          .then(function(i) {
            console.log(`debug: ${i}`);
          });

        return tdm.createDeliverySlot.call(id, warehouseName, isTradeable, from, to, price, gate, deliveryType, account)
          .then(function(ds) {
              console.log('DeliverySlot: ', ds);
            })
            .catch(function(error) {
              console.log(`error ${error}`);
            });

    })
    .then(function() {
      console.log('create delivery slot success');
    })
    .catch(function(error) {
      console.log(error);
    });
  },

  updateDeliverySlot: function() {
    var self = this;

    var tdm;
    TimeDeliveryManagement.deployed()
      .then(function(instance) {
        tdm = instance;

        return tdm.update(123434, true, "string from", "string to", 25, "string gate", "string warehouseName", "string deliveryType");
    })
    .then(res => console.log(res))
    .catch(error => {
      console.log(error);
      self.setStatus(`Error ${error}`);
    });
  },

  sendRequest:function() {
    var self = this;

    var from = document.getElementById("from").value;
    var to = document.getElementById("to").value;
    var date = document.getElementById('datePicker').value;
    var type = document.getElementById("deliveryType").value;

    console.log(`von: ${from} bis ${to} Uhr am ${date} mit dem Typ: ${type}`);
  }

};


window.addEventListener('load', function() {
  // Checking if Web3 has been injected by the browser (Mist/MetaMask)
  if (typeof web3 !== 'undefined') {
    console.warn("Using web3 detected from external source. If you find that your accounts don't appear or you have 0 MetaCoin, ensure you've configured that source properly. If using MetaMask, see the following link. Feel free to delete this warning. :) http://truffleframework.com/tutorials/truffle-and-metamask")
    // Use Mist/MetaMask's provider
    window.web3 = new Web3(web3.currentProvider);
  } else {
    console.warn("No web3 detected. Falling back to http://127.0.0.1:9545. You should remove this fallback when you deploy live, as it's inherently insecure. Consider switching to Metamask for development. More info here: http://truffleframework.com/tutorials/truffle-and-metamask");
    // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
    window.web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:7545"));

  }

  App.start();
});
