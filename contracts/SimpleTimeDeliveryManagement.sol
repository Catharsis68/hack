
//https://github.com/willitscale/solidity-util#concatstring--string kopiert
import "github.com/willitscale/solidity-util/lib/Strings.sol";
//import "./Strings.sol";

pragma solidity ^0.4.0;

contract SimpleTimeDeliveryManagement {
    using Strings for string;

    struct DeliverySlot{
        uint id;
        string  warehousename;
        address supplierAd;
    }

    struct Supplier {
        address supId;

    }

    string public debug ;
    uint public maxDSId;
    address public warehouse;
    mapping(uint => DeliverySlot)  public slots;
    mapping(address => Supplier) suppliers;


    function SimpleTimeDeliveryManagement() public {
            warehouse = msg.sender;
            debug = "started";
            maxDSId =0;
    }


//e.g. 1,"Warehousname",true,0,0,0,"A1","Food","0xca35b7d915458ef540ade6068dfe2f44e8fa733c"
//e.g. 1,"Warehousname","0xca35b7d915458ef540ade6068dfe2f44e8fa733c"

    function createDeliverySlot(uint id, string warehousename, address ownAdress)  public returns (uint)
    {
        if (msg.sender != warehouse) return;
        maxDSId++;
        uint currentID = maxDSId;

        slots[currentID] = DeliverySlot(currentID,warehousename, address(0));
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
        return success;
    }




}
