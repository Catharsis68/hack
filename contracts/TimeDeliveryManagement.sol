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
       string  warehouseName;
       string  deliveryType;
   }

   struct Supplier {
       address userId;
       DeliverySlot[] deliverySlots;
   }

   uint256 public maxid;

   address public warehouse;
   mapping(address => Supplier) suppliers;


   function TimeDeliveryManagement() public {
           warehouse = msg.sender;
           debug = "wir gewinnen";
           maxid = 0;
       }

   function createDeliverySlot()  public {
       if (msg.sender != warehouse) return;
            suppliers[msg.sender].deliverySlots.push(DeliverySlot({
               id: maxid++, isTradeable: true, timeFrom: "gestern", timeTo: "heute", price:5, gate:"123", warehouseName: "Warenhaus1", deliveryType: "Eis"
           }));
           debug = "hat geklappt";
   }

   function update(uint256 id, bool isTradeable, string from, string to, uint price, string gate, string warehouseName, string deliveryType)  public {
       if (msg.sender != warehouse) return;
            suppliers[msg.sender].deliverySlots.push(DeliverySlot({
              id: id, isTradeable: isTradeable, timeFrom: from, timeTo: to, price: price, gate: gate, warehouseName: warehouseName, deliveryType: deliveryType
           }));
           debug = "hat geklappt";
   }

   function getFirstDeliverySlots(uint256 indexofDS) public returns (string success)
   {
       success = suppliers[warehouse].deliverySlots[indexofDS].timeFrom;
   }

   function getAllDeliverySlots(string searchstring) public returns (string success)
   {
       string storage s1 = suppliers[warehouse].deliverySlots[0].timeFrom;
       string storage s2 = suppliers[warehouse].deliverySlots[0].timeTo;
       success = s1;
   }

   function bookDeliverySlot(uint256 idOfDS) public returns (string success)
   {
     DeliverySlot storage deSlot = suppliers[warehouse].deliverySlots[0];
     deSlot.isTradeable = false;
     suppliers[msg.sender].deliverySlots.push(deSlot);
   }

}
