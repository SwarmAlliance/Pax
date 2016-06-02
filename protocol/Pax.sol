    /// @title Pax
    /// @author Physes

    import "Utilities.sol";
    import "Persona.sol";
    import "Diaspora.sol";

contract Administered {

}
    
contract Pax is Administered {


    struct Persona {
        bytes32 id;
        int status;
        int exit;
        int publicity;
        address at;
    }
    
    uint populace;
    uint districts;
    uint economy;
    
    mapping(uint => Citizen) Populace;
    mapping(uint => Hub) Districts;
    mapping(uint => Company) Economy;

    
    function paxEnter() {
        address _address = msg.sender;
        address _client = new Persona(msg.sender);
        _client
        
    }

   function Register(int _formationCode,
                    int _exit,
                    int _publicity,
                    int _status,
                    bytes32 _id,
                    address _at) returns (bool output) {
        
        if(_formationCode = 0) {
            Persona citizen;
            citizen.exit = _exit;
            citizen.publicity = _publicity;
            citizen.status = _status;
            citizen.id = _id;
            citizen.at = _at;
            
            Populace[populace++] = citizen;
            
        } else if(_formationCode = -1) {
            Persona hub;
            hub.exit = _exit;
            hub.publicity = _publicity;
            hub.status = _status;
            hub.id = _id;
            hub.at = _at;
            
            Districts[districts++] = hub;
            
        } else if(_formationCode = 1) {
            Persona company;
            company.exit = _exit;
            company.publicity = _publicity;
            company.id = _id;
            company.at = _at;
            
            Economy[economy++] = company;
        }
    }
}