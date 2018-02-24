// Import the page's CSS. Webpack will know what to do with it.
import "../stylesheets/app.css";
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

    console.log('isConnected', web3.isConnected());
    console.log(web3.currentProvider);
    // web3.eth.call({type: '90'});

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

      self.createDeliverySlot();
    });
  },

  setStatus: function(message) {
    var status = document.getElementById("status");
    status.innerHTML = message;
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

    this.setStatus("Initiating transaction... (please wait)");

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

  createDeliverySlot: function() {
    var self = this;

    var tdm;
    var contract;
    TimeDeliveryManagement.deployed().then(function(instance) {
      tdm = instance;
      contract = tdm.contract;

      console.log('contract ', contract);

      // API ref: myContract.methods.myMethod(123)
      console.log('contract.address', contract.address);
      console.log('account ', account);
      console.log('send ', contract.createDeliverySlot().send({from: account}));
      // console.log('send ', contract.createDeliverySlot().call({from: account}));

      // invoke method then send


      return tdm.contract.createDeliverySlot();

      // return tdm.createDeliverySlot(123434, true, "string from", "string to", 25, "string gate", "string warehouseName", "string deliveryType");
    })
    .then(function(res) {
      self.setStatus("Transaction complete!");
      console.log('create delivery slot success', res);
    })
    .catch(function(error) {
      console.log(error);
      self.setStatus(`Error ${error}.`);
    });
  },

  updateDeliverySlot: function() {
    var self = this;

    var tdm;
    TimeDeliveryManagement.deployed().then(function(instance){
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

    var from = parseInt(document.getElementById("from").value);
    var to = parseInt(document.getElementById("to").value);

    var e = document.getElementById("deliveryType");
    var type = e.options[e.selectedIndex].text;

    var date = document.getElementById('datePicker').value;
    // valueAsDate // valueAsNumber

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
