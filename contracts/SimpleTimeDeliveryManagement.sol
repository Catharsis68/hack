pragma solidity ^0.4.0;

contract SimpleTimeDeliveryManagement {

    struct DeliverySlot{
        uint id;
        string  warehousename;
        address supplierAd;
    }

    struct Supplier {
        address supId;
    }

    uint public maxDSId;
    address public warehouse;
    mapping(uint => DeliverySlot)  public slots;
    mapping(address => Supplier) suppliers;


    function SimpleTimeDeliveryManagement() public {
            warehouse = msg.sender;
            maxDSId =0;
    }

//e.g. 1,"Warehousname","0xca35b7d915458ef540ade6068dfe2f44e8fa733c"

    function createDeliverySlot(uint id, string warehousename, address ownAdress)  public
    {
        maxDSId++;
        uint currentID = maxDSId;
        slots[currentID] = DeliverySlot(currentID,warehousename, address(0));
    }



    function createSupplier(address fromAddress)  public returns (bool success)
    {
        suppliers[fromAddress] = Supplier(fromAddress);
        return success;
    }

}
