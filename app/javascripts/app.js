// Import the page's CSS. Webpack will know what to do with it.
import "../stylesheets/app.css";
var { now } = require('./utils.js');
// var faker = require('faker');

// Import libraries we need.
import { default as Web3} from 'web3';
import { default as contract } from 'truffle-contract'

// Import our contract artifacts and turn them into usable abstractions.
import metacoin_artifacts from '../../build/contracts/MetaCoin.json'
import tdm_artifacts from '../../build/contracts/TimeDeliveryManagement.json'

// MetaCoin is our usable abstraction, which we'll use through the code below.
var MetaCoin = contract(metacoin_artifacts);
var TimeDeliveryManagement = contract(tdm_artifacts);

// The following code is simple to show off interacting with your contracts.
// As your needs grow you will likely need to change its form and structure.
// For application bootstrapping, check out window.addEventListener below.
var accounts;
var account;


window.App = {
  start: function() {
    var self = this;

    document.getElementById('datePicker').valueAsDate = new Date();

    // Bootstrap the MetaCoin abstraction for Use.
    // MetaCoin.setProvider(web3.currentProvider);

    // Init TimeDeliveryManagement
    TimeDeliveryManagement.setProvider(web3.currentProvider);

    // TODO remove
    // web3.eth.getBlock(48, function(error, result){
    //     if(!error)
    //         console.log(JSON.stringify(result));
    //     else
    //         console.error(error);
    // })


    // Get the initial account balance so it can be displayed.
    web3.eth.getAccounts(function(err, accs) {
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

      console.log('account', account);

      self.listDeliverySlots();
      self.createDeliverySlot();
    });
  },

  refreshBalance: function() {
    var self = this;

    var meta;
    MetaCoin.deployed().then(function(instance) {
      meta = instance;
      return meta.getBalance.call(account, {from: account});
    }).then(function(value) {
      var balance_element = document.getElementById("balance");
      balance_element.innerHTML = value.valueOf();
    }).catch(function(e) {
      console.log(e);
      self.setStatus("Error getting balance; see log.");
    });
  },

  sendCoin: function() {
    var self = this;

    var amount = parseInt(document.getElementById("amount").value);
    var receiver = document.getElementById("receiver").value;

    var meta;
    MetaCoin.deployed().then(function(instance) {
      meta = instance;
      return meta.sendCoin(receiver, amount, {from: account});
    }).then(function() {
      self.setStatus("Transaction complete!");
      self.refreshBalance();
    }).catch(function(e) {
      console.log(e);
      self.setStatus("Error sending coin; see log.");
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

  // function createSupplier(address fromAddress)  public returns (bool success)
  /* createSupplier: function() {
    var self = this;
    var tdm;

    TimeDeliveryManagement.deployed()
      .then(function(instance)) {
        tdm = instance;

        return tdm.createSupplier().send({from: account});

        // contract.createSupplier()
        //   .send({from: account})
        //   .then(function(data) {
        //       console.log('data', data);
        // });
      }
      .catch(function(error) {
        console.log(error);
        self.setStatus(`Error ${error}.`);
      });
  }, */

  createDeliverySlot: function() {
    var self = this;

    var tdm;
    var contract;
    TimeDeliveryManagement.deployed()
      .then(function(instance) {
        tdm = instance;
        contract = tdm.contract;

        console.log('contract ', contract);

        // API ref: myContract.methods.myMethod(123)
        console.log('contract.address', contract.address);
        console.log('account ', account);

        let id = 111;
        let warehouseName = 'penny';
        let isTradeable = true;
        let from = 12345;
        let to = 54321;
        let price = 25;
        let gate = 'gateName';
        let deliveryType = 'food'
        //
        // contract.createDeliverySlot(id, warehouseName, isTradeable, from, to, price, gate, deliveryType)
        //   .send({from: account})
        //   .then(function(ds) {
        //       console.log('ds', ds);
        //     })
        //     .catch(function(error) {
        //       console.log(`error ${error}`);
        //     });

        // return tdm.contract.createDeliverySlot('warehouseName',1519457019, 1519457043, 35, 'gate25', 'food'); // .send({from: account});
    })
    .then(function(res) {
      console.log('create delivery slot success', res);
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
    window.web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:9545"));
  }

  App.start();
});
