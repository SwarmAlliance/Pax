/// @title Persona 0.1: The universal Pax identity file
/// @author Physes

import "Utilities.sol";

contract generalPersona {
    
    address owner;
    address[] trustees;
    
    struct Persona {
		bytes32[] name;
		bytes32[][] residency;
		bytes32 id;
		string origin;
		uint id_interval;
		uint access;
		int birth;
		int exit;
		int publicity;
		int status;
		Sex assigned;
    }

	enum Sex{ Male, Female, Uncategorized }

    event broadcastUpdate(bytes32 _id, string _broadcast, uint time);
	event broadcastNewClient(bytes32 _id, uint time);
	event broadcastNameChange(bytes32[] name, uint time);
	event broadcastQuery(address query, uint time);
	event broadcastIdChange(bytes32 _oldId, bytes32 _newId, string _broadcast, uint time);
	event broadcastExit(bytes32 _id, int _status, string _broadcast, uint time);
	

	
	modifier onlyOwner {
	    if(msg.sender != owner) throw;
	    _
	}
	
	modifier inGroup {
	    if(msg.sender != owner) throw;
	    for(uint d = 0; d < trustees.length; d ++) {
	        if(msg.sender != trustees[d]) throw;
	    }
	    _
	}

	modifier outGroup {
	    if(msg.sender != owner) broadcastQuery(msg.sender, now);
	    for(uint k = 0; k < trustees.length; k++) { 
	        if(msg.sender != trustees[k]) broadcastQuery(msg.sender, now);
	    } 
	    _
	}
	
	modifier onlyCitizens {
	    if(msg.sender == owner || Persona.status >= 10) {
	        _
	    }
	}
		
	function generalPersona(){
	    owner = msg.sender;
	    
	    Persona.exit = 0;
	    Persona.publicity = 0;
	    Persona.status = 01;
	    Persona.id = sha3(Persona.birth, Persona.name, now);
	    Persona.id_changed = now;
	    
	    broadcastNewClient(Persona.id, now);
    }
    
    function setName(bytes32[] _newName) inGroup returns(bool success) {
        string output = "Name was changed.";
        if(_newName.length > 5) throw;
        Persona.name = _newName;
        broadcastUpdate(Persona.id, output, now);
        return true;
    }
    
    
    function setSex(int input) inGroup returns (bool output) {
	    string _output;
	    
	    if(input > 1 || input < -1) throw;
	    if(input = 1) {
	        Persona.assigned = Sex.Male;
	        _output = "Sex is male";
	        
	    } else if(input = -1) {
	        Persona.assigned = Sex.Female;
	        output = "Sex is female";
	    } else if(input = 0) {
	        Persona.assigned = Sex.Uncategorized;
	        output = "Sex in uncategorized";
	    }
	    broadcastUpdate(Persona.id, _output, now);
	    return true;
	}
	
	function setOrigin(bytes32 input) inGroup outGroup returns (bool output) {
	    string _output = "Origin established.";
        if(Persona.id != "") throw;
        if(input = "") throw;
        Persona.origin = input;
        broadcastUpdate(Persona.id, _output, now);
        return true;
	}
	
	function setBirth(int input) inGroup outGroup returns (bool output) {
	   if(input != 0 && input < now - 1 years) {
	        Persona.birth = input;
	    }
	    string _output = "Birth established";
	    broadcastUpdate(Persona.id, _output, now);
	    return true;
	}
	
	function changeAddress(bytes32[] input) inGroup outGroup returns (bool output) {
	    if(input.length > 5) throw;
	    uint x = Persona.residency.length + 1;
	        Persona.residency[][x].push = input;
	        string _output = "Address changed";
	        broadcastUpdate(Persona.id, _output, now);
	        return true;
	}
	
	function changeId() onlyOwner returns (bytes32 output) {
	    if(now - 90 days > Persona.id_changed) {
	        bytes32 oldId = Persona.id;
	        Persona.id = sha3(Persona.birth, Persona.name, now);
	        string _output = "ID changed";
	        broadcastIdChange(oldId, Persona.id, _output, now);
	    }   
	}
	
	function addTrustees(address[] input) private onlyOwner returns (bool output) {
	    uint _trustees = trustees.length;
	    if(input.length > 5 - _trustees) throw;
	        trustees.push(input);
	    string _output = "Trustee added";
	    broadcastUpdate(Persona.id, _output, now);
	    return true;
	}
	
	function removeTrustees(address[] input) private onlyOwner returns (bool output) {
	    if(input.length > 5) throw;
	    for(uint v = 0; v < input.length; v++) {
	        for(uint u = 0; u < trustees.length; u++) {
	            if(input[v] = trustees[u]) {
	                delete(trustees[u]);
	            }
	        }
	    }
	    string _output = "Trustee removed";
	    broadcastUpdate(Persona.id, _output, now);
	    return true;
	}
	
	function checkStatus(bytes32 input) returns (bytes32 output) {
	    if(input = Persona.id) {
	        return Persona.status;
	    }
	} 
	
	function exit(int input) inGroup returns (bool output) {
	    if(input < -1 || input > 1) throw;
	    Persona.status = input;
	    string _output;
	    if(input = 1) {
	        _output = "Honorable Exit";
	    } else if(input = 0) {
	        _output = "Returned";
	    } else {
	        _output = "Dishonorable Exit";
	    }
	    broadcastExit(Persona.id, input, _output, now);
	    return true;
	}
	
	function Delete(address input) onlyOwner returns(bool output) {
	    suicide(this);
	    msg.value.send(input);
	    return true;
	}
	
	function publicity(){}
	
	function batchInput(bytes32[] _name, 
	                    bytes32[] _residency,
	                    string _origin,
	                    int _birth,
	                    int _setting,
	                    int _sex) inGroup returns(bool output) {
	   setName(_name);
	   changeAddress(_residency);
	   setOrigin(_origin);
	   setBirth(_birth);
	   publicity(_setting);
	   setSex(_sex);
	   
	   return true;
	  
	}
	
	function batchOutput(bytes32 _id) returns(
	    uint timestamp,
		string _name,
		string _address,
		string _origin,
		bytes32 _residency,
		string _sex,
		uint _birth,
		uint _access,
		int _exit,
        int _status) {
            
        string newName = Utilities.bytes32ArrayToString(Persona.name, true);
        string newAddress = Utilities.addressToString(owner);
        string newResidency = Utilities.bytes32ArrayToString(Persona.residency, true);
        string sex;
        
        if(Persona.assigned = Sex.Male) {
            sex = "Male";
        } else if(Persona.assigned = Sex.Female) {
            sex = "Female";
        } else {
            sex = "Uncategorized";
        }
		    
		    return now;
		    return newName;
		    return newAddress;
		    return Persona.origin;
		    return newResidency;
		    return sex;
		    return Persona.birth;
		    return Persona.access;
		    return Persona.exit;
		    return Persona.status;
		    
        }
}
