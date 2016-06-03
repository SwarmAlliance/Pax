import "Administered.sol";

contract Mint is Administered {
    

    address reserve = this;

    uint public tokens; // in grams
    uint public supply; // in pennies (*100 for credits)
    
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    mapping (address => bool) public banned;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Banned(address target, bool banned);
    
    function Mint() {
        owner = msg.sender;
        balanceOf[reserve] = supply;
        bytes3 name = TX;
        string symbol = "&#9934;"; //UTF-8 symbol => Ophiucus
    }
    
    function transfer(address _to, uint256 _value) {
    
    if (banned[msg.sender]) throw;
    if (balanceOf[msg.sender] < _value) throw;          
    if (balanceOf[_to] + _value < balanceOf[_to]) throw; 
        balanceOf[msg.sender] -= _value;                     
        balanceOf[_to] += _value;                            
        Transfer(msg.sender, _to, _value);                   
    }
    
    
    function tokensToSupply (uint dgx) internal returns (uint tx) {
        return gramsToPennies(dgx);
    }

    function gramsToPennies(uint grams) internal returns(uint pennies) {
        uint troy = ((grams * 100000)/2834952);
        return (troy * 100000);
    }

    function penniesToCredits(uint pennies) internal returns(uint credits) {
        return pennies/100;
    }
    
    function penniesToOunces(uint pennies) internal returns(uint ounces) {
        return pennies/100000;
    }
    
    function gramsToOunces(uint grams) internal returns(uint ounces) {
        uint d = gramsToPennies(grams);
        return penniesToOunces(d);
    }
    


    function banAccount(address target, bool banned) onlyOwner {
        Banned[target] = banned;
        Banned(target, banned);
    }

}

contract Exchange() {
    
}

contract Reserve() {
    
}