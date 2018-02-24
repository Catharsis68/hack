
//import "github.com/willitscale/solidity-util/lib/Strings.sol";
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


//e.g. 1,"Warehousname",true,0,0,0,"A1","Food","0xca35b7d915458ef540ade6068dfe2f44e8fa733c"

    function createDeliverySlot(uint id, string warehousename,bool isTradeable,uint32 timeFrom,uint32 timeTo,uint price,string gate,string logisticType, address ownAdress)  public returns (uint)
    {
        if (msg.sender != warehouse) return;
        maxDSId++;
        uint currentID = maxDSId;

        suppliers[warehouse].deliverySlots[currentID] = DeliverySlot(currentID,warehousename, true,timeFrom,timeTo,price,gate,logisticType, address(0));
        debug = "successful createDeliverySlot";

        return currentID+maxDSId;
    }



    function createSupplier(address fromAddress)  public returns (bool success)
    {
      //generate address in web3?
      //initalise a amount of money?
        if (msg.sender != warehouse) return;

        suppliers[fromAddress] = Supplier(fromAddress);
        debug = "successful createSupplier";
        success = true;
        return success;
    }


    function getAllDeliverySlots(int fromTimeFilter, int toTimeFilter) public view returns (uint[3] arrayIDs)
    {
        for (uint i = 1; i < maxDSId; i++) {
          if(arrayIDs[2] != 0) break;
          if(suppliers[warehouse].deliverySlots[i].timeTo < toTimeFilter && suppliers[warehouse].deliverySlots[i].timeFrom < fromTimeFilter && suppliers[warehouse].deliverySlots[i].isTradeable)
          arrayIDs[i-1]=i;
        }
        return arrayIDs;
    }

    function getDetailsDeliverySlots(uint idDS) public view returns (uint id, string warehousename,bool isTradeable,uint32 timeFrom,uint32 timeTo,uint price,string gate,string logisticType, address ownAdress)
    {
      DeliverySlot storage myDelSlot = suppliers[warehouse].deliverySlots[idDS];
      //check if owner is warehouse or sender
      if(myDelSlot.supplierAd == address(0) || myDelSlot.supplierAd ==msg.sender  ){
        id = myDelSlot.id;
        warehousename = myDelSlot.warehousename;
        isTradeable = myDelSlot.isTradeable;
        timeFrom = myDelSlot.timeFrom;
        timeTo = myDelSlot.timeTo;
        price = myDelSlot.price;
        gate = myDelSlot.gate;
        logisticType = myDelSlot.logisticType;
        ownAdress = myDelSlot.supplierAd;

      }

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

    function toBytes(uint256 x) returns (bytes b) {
        b = new bytes(32);
        assembly { mstore(add(b, 32), x) }
    }



}
