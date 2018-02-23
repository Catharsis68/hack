
//import "https://github.com/Arachnid/solidity-stringutils/blob/master/strings.sol";

pragma solidity ^0.4.0;

contract TimeDeliveryManagement {

    string public debug ;

    struct DeliverySlot{
        uint256 id;
        bool    isTradeable;
        string  timeFrom;
        string  timeTo;
        uint    price;
        string  gate;
        string  warehousename;
        string  logisticType;
    }

    struct Supplier {
        address userId;
        mapping (uint256 => DeliverySlot) deliverySlots;
        //DeliverySlot[] deliverySlots;
    }

    uint256 public maxid;

    address public warehouse;
    mapping(address => Supplier) suppliers;


    function TimeDeliveryManagement() public {
            warehouse = msg.sender;
            debug = "wir gewinnen";
            maxid =0;
        }

    function createDeliverySlot()  public returns (uint256 currentID
      ) {
        if (msg.sender != warehouse) return;
        currentID = maxid++;
        suppliers[msg.sender].deliverySlots[currentID] = DeliverySlot(currentID,true,"gestern","heute",5,"123","Warenhaus1", "Food" );
        debug = "hat geklappt";
        return currentID;
    }

    function getFirstDeliverySlots(uint256 indexofDS) public returns (string success)
    {
        //prüfe Vergangeheit
        success = suppliers[warehouse].deliverySlots[indexofDS].timeFrom;
        return success;
    }

    function getAllDeliverySlots(string searchstring) public returns (string success)
    {
        //prüfe Vergangeheit
        string storage s1=  suppliers[warehouse].deliverySlots[0].timeFrom;
        string storage s2=  suppliers[warehouse].deliverySlots[0].timeTo;
        return s1;
    }

    function purchaseDeliverySlot(uint256 idOfDS) public returns (bool success)
    {
      //prüfe Vergangeheit
      DeliverySlot storage deSlot = suppliers[warehouse].deliverySlots[idOfDS];
      deSlot.isTradeable = false;
      suppliers[msg.sender].deliverySlots[idOfDS] = deSlot;
      return true;
    }

    function offerDeliverySlot(uint256 idOfDS) public returns (bool success)
    {
      //prüfe Vergangeheit
      DeliverySlot storage deSlot =suppliers[msg.sender].deliverySlots[idOfDS] = deSlot;
      deSlot.isTradeable = true;
      return true;
    }

    function setBuyOrderDeliverySlot() public returns (bool success)
    {
      //prüfe Vergangeheit
      //Foreach offener Blockchains
      return true;
    }

}
