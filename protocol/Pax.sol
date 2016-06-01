    /// @title Pax
    /// @author Physes
    
    import "Utilities.sol";
    import "Persona.sol";
    import "Diaspora.sol";
    
contract Pax {


    struct Citizen {
        bytes32 id;
        int status;
        int exit;
        int publicity;
        address at;
    }

    struct Company {
        bytes32 name;
        bytes32 id;
        address at;
    }

    struct Hub {
        bytes32 id;
        int status;
        mapping(uint => Citizen) internal Citizens;
        mapping(uint => Company) public District;
    }

    mapping(uint => Citizen) Population;
    mapping(uint => Hub) Hubs;
    mapping(uint => Company) Economy;

    
    function paxEnter() {
        address _address = msg.sender;
        address _client = new Persona(msg.sender);
        clients.push(_client);
    }
}