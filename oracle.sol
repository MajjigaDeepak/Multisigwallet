pragma solidity ^0.4.22;
import "github.com/provable-things/ethereum-api/provableAPI_0.4.25.sol";

contract ExampleContract is usingProvable {

   string public ETHUSD;
   uint  x;
   uint  y;
   uint  value;
   event LogConstructorInitiated(string nextStep);
   event LogPriceUpdated(string price);
   event LogNewProvableQuery(string description);

   function ExampleContract() payable {
       LogConstructorInitiated("Constructor was initiated. Call 'updatePrice()' to send the Provable Query.");
   }

   function __callback(bytes32 myid, string result) {
       if (msg.sender != provable_cbAddress()) revert();
       ETHUSD = result;
       LogPriceUpdated(result);
   }

   function updatePrice(uint _x) public payable returns (uint, uint) {
       if (provable_getPrice("URL") > this.balance) {
           LogNewProvableQuery("Provable query was NOT sent, please add some ETH to cover for the query fee");
       } else {
           x = _x;
           LogNewProvableQuery("Provable query was sent, standing by for the answer..");
           provable_query("URL", "json(https://api.pro.coinbase.com/products/ETH-USD/ticker).price");
           value = msg.value;
           return (x, value);
       }
   }

    function getX() public view returns (uint) {
        y = st2num(ETHUSD);
        return y;

    }

    function st2num(string memory numString) pure returns(uint) {
        uint  val=0;
        bytes   memory stringBytes = bytes(numString);
        for (uint  i =  0; i<stringBytes.length; i++) {
            uint exp = stringBytes.length - i;
            bytes1 ival = stringBytes[i];
            uint8 uval = uint8(ival);
           uint jval = uval - uint(0x30);
   
           val +=  (uint(jval) * (10**(exp-1))); 
        }
      return val;
    }
}