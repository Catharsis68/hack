
//import "https://github.com/Arachnid/solidity-stringutils/blob/master/strings.sol";

//https://github.com/willitscale/solidity-util#concatstring--string kopiert
import "./Strings.sol";

pragma solidity ^0.4.0;

contract TimeDeliveryManagement {
    using Strings for string;

    struct DeliverySlot{
        uint id;

        string  warehousename;
        bool    isTradeable;
        uint32  timeFrom;
        uint32  timeTo;
        uint    price;
        string  gate;
        string  logisticType;
        address supplierAd;
    }

    struct Supplier {
        address supId;
        mapping (uint => DeliverySlot) deliverySlots;
    }

    string public debug ;
    uint public maxDSId;
    address public warehouse;
    mapping(address => Supplier) suppliers;


    function TimeDeliveryManagement() public {
            warehouse = msg.sender;
            debug = "started";
            maxDSId =0;
    }

    function createDeliverySlot(string warehousename,uint32 timeFrom,uint32 timeTo,uint price,string gate,string logisticType)  public returns (uint currentID)
    {
        if (msg.sender != warehouse) return;
        currentID = maxDSId++;

        suppliers[msg.sender].deliverySlots[currentID] = DeliverySlot(currentID,warehousename, true,timeFrom,timeTo,price,gate,logisticType, address(0));
        debug = "successful createDeliverySlot";
        return currentID;
    }

    function createSupplier(address fromAddress)  public returns (bool success)
    {
      //generate address in web3?
      //initalise a amount of money?
        if (msg.sender != warehouse) return;

        suppliers[fromAddress] = Supplier(fromAddress);
        debug = "successful createSupplier";
        return success;
    }


    function getAllDeliverySlots(string searchstring) public returns (string response)
    {
        response = "{[";

        for (uint i = 1; i < maxDSId; i++) {
          DeliverySlot storage myDelSlot = suppliers[warehouse].deliverySlots[i];
          //check if Old  //check if available
          if(myDelSlot.timeTo > block.timestamp || !myDelSlot.isTradeable) continue;

          response.concat("{");
          response.concat(myDelSlot.warehousename).concat(" , ");
          //success.concat(myDelSlot.timeFrom).concat(" , ");
          //success.concat(myDelSlot.timeTo).concat(" , ");
          response.concat(myDelSlot.gate).concat(" , ");
          response.concat(myDelSlot.logisticType).concat(" , ");
          response.concat("},");
          //Todo , not in last record
        }
        response.concat("]}");
        debug = "successful getAllDeliverySlots";

        return response;
    }

    function purchaseDeliverySlot(uint idOfDS) public returns (bool success)
    {
      DeliverySlot storage myDelSlot = suppliers[warehouse].deliverySlots[idOfDS];
      //check if Old and isTradeable
      if(myDelSlot.timeTo > block.timestamp || !myDelSlot.isTradeable) return false;

      myDelSlot.isTradeable = false;
      myDelSlot.supplierAd = msg.sender;
      suppliers[warehouse].deliverySlots[idOfDS] = myDelSlot;

      return true;
    }

    function offerDeliverySlot(uint idOfDS) public returns (bool success)
    {
      DeliverySlot storage myDelSlot =suppliers[msg.sender].deliverySlots[idOfDS];
      //check if Old
      if(myDelSlot.timeTo <   block.timestamp) return false;
      // nur besizte darf freigeben
      if(myDelSlot.supplierAd != msg.sender) return false;


      myDelSlot.isTradeable = true;
      return true;
    }

    function setBuyOrderDeliverySlot() public returns (uint dsID)
    {
      dsID = 0;
      uint  minimaltimestamp;
      minimaltimestamp = 2147483648;
      //Foreach available Slot
      for (uint i = 1; i < maxDSId; i++) {
        DeliverySlot storage myDelSlot = suppliers[warehouse].deliverySlots[i];
        //check if Old //check if available
        if(myDelSlot.timeFrom >   block.timestamp || !myDelSlot.isTradeable) continue;
        if(myDelSlot.timeFrom <minimaltimestamp)
          dsID= myDelSlot.id;
      }

      return dsID;
    }

}
