
//import "https://github.com/Arachnid/solidity-stringutils/blob/master/strings.sol";

//https://github.com/willitscale/solidity-util#concatstring--string kopiert
import "./Strings.sol";

pragma solidity ^0.4.0;

contract TimeDeliveryManagement {

    using Strings for string;
    string public debug ;

    struct DeliverySlot{
        uint id;
        bool    isTradeable;
        uint  timeFrom;
        uint  timeTo;
        uint    price;
        string  gate;
        string  warehousename;
        string  logisticType;
    }

    struct Supplier {
        address userId;
        mapping (uint => DeliverySlot) deliverySlots;
        //DeliverySlot[] deliverySlots;
    }

    uint public maxid;

    address public warehouse;
    mapping(address => Supplier) suppliers;


    function TimeDeliveryManagement() public {
            warehouse = msg.sender;
            debug = "wir gewinnen";
            maxid =0;
        }

    function createDeliverySlot()  public returns (uint currentID
      ) {
        if (msg.sender != warehouse) return;
        currentID = maxid++;
        suppliers[msg.sender].deliverySlots[currentID] = DeliverySlot(currentID,true,1245,1234,5,"123","Warenhaus1", "Food" );
        debug = "hat geklappt";
        return currentID;
    }

    function getFirstDeliverySlots(uint indexofDS) public returns (string success)
    {
        //prüfe Vergangeheit
        success = suppliers[warehouse].deliverySlots[indexofDS].warehousename;
        return success;
    }

    function getAllDeliverySlots(string searchstring) public returns (string success)
    {

        success = "{[";

        for (uint i = 1; i < maxid; i++) {
          //check if Old
          if(myDelSlot.timeTo >   block.timestamp) continue;
          //check if available

          success.concat("{");
          DeliverySlot storage myDelSlot = suppliers[warehouse].deliverySlots[i];
          success.concat(myDelSlot.warehousename).concat(" , ");
          //success.concat(myDelSlot.timeFrom).concat(" , ");
          //success.concat(myDelSlot.timeTo).concat(" , ");
          success.concat(myDelSlot.gate).concat(" , ");
          success.concat(myDelSlot.logisticType).concat(" , ");
          success.concat("}");
        }
        success.concat("]}");

        return success;
    }

    function purchaseDeliverySlot(uint idOfDS) public returns (bool success)
    {
      DeliverySlot storage myDelSlot = suppliers[warehouse].deliverySlots[idOfDS];
      //check if Old
      if(myDelSlot.timeTo >   block.timestamp) return false;

      myDelSlot.isTradeable = false;
      suppliers[msg.sender].deliverySlots[idOfDS] = myDelSlot;
      return true;
    }

    function offerDeliverySlot(uint idOfDS) public returns (bool success)
    {
      DeliverySlot storage myDelSlot =suppliers[msg.sender].deliverySlots[idOfDS];
      //check if Old
      if(myDelSlot.timeTo >   block.timestamp) return false;

      myDelSlot.isTradeable = true;
      return true;
    }

    function setBuyOrderDeliverySlot() public returns (bool success)
    {

      //Foreach available Slot
      return true;
    }

}
