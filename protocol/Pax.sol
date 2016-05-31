    /// @title Pax
    /// @author Physes
    
    import "Utilities.sol";
    import "Persona.sol";
    import "Diaspora.sol";
    
contract Pax {
    address[] clients;
    
    function paxEnter() {
        address _address = msg.sender;
        address _client = new Persona(msg.sender);
        clients.push(_client);
    }
}