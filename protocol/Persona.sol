/// @title Persona 0.1: The universal Pax identity file
/// @author Physes

contract Persona {
    
    ///@param state variables related to identity
		string[] public name;
		bytes32 public id;
		bytes32 public origin;
		bytes32[] public residency;
		address public persona;
        address[] diaspora;
		uint public birth;
		uint public access;
		int public exit;
		int public status;
		Gender public gender;

		
	struct Gender {
	    bool male;
	    bool female;
	    bool uncategorized;
	}
		
	event broadcastNewClient(bytes32 _id);
	event broadcastNameChange(bytes32[] name);
	event broadcastQuery(address query);
	
	modifier inGroup {
	    if(msg.sender != persona) throw;
	    for(uint d = 0; d < diaspora.length; d ++) {
	        if(msg.sender != diaspora[d]) throw;
	    }
	    _
	}
	/* FOR LATER
	modifier outGroup {
	    if( msg.sender != persona ||
	        for(uint k = 0; k < diaspora.length; k++) { 
	        msg.sender != diaspora[k]
	    } ) 
	    broadcastQuery(msg.sender);
	    _
	}*/
		
	function Persona(bytes32[] _name,
	                bytes32 _origin,
	                uint _birth,
	                bool _male,
	                bool _female,
	                bytes32[] _residency
	                ) {
	   
	        persona = msg.sender;
	                    
	     if(_name.length == 0 || _name.length > 5) throw;
	     for(uint a = 0; a < _name.length; a++) {
	         name[a] = _name[a];
	     }
	     
	     if(_origin == "" ) {
	         _origin = "Unknown";
	     } else {
	         _origin == origin;
	     }
	     
	      if(_birth == 0 || _birth > now) {
	         throw;
	     } else {
	        birth = _birth;
	     }
	     
	     if(_male == true && _female == true) {
	        throw;
	     } else if (_male == false && _female == false) {
	         gender.uncategorized == true;
	     } else if(_male) {
	         gender.male == true;
	         gender.female == false;
	         gender.uncategorized == false;
	     } else if(_female) {
	        gender.female == true;
	        gender.male == false;
	        gender.uncategorized == false;
	     }
	     
	    if(_residency.length > 5) throw;
	    if(_residency.length == 0) {
	        residency[0] = "Unknown";
	    }
	 
	    for(uint b = 0; b < _residency.length; b++) {
	        _residency[b] = residency[b];
	                }
	  
	    exit = 0; 
	    status = 1;
	    id = sha3(birth, name);
    
    //broadcast a new client added to the network
	    broadcastNewClient(id);
	     
    }
		
		function changeOfName(bytes32[] _newName) inGroup returns(bool success) {
		    if(_newName.length > 5) throw;
		    for(uint c = 0; c < _newName.length; c++) {
	            name[c] = _newName[c];
		    }
	//broadcast change of name
        broadcastNameChange(name);
        return true;
		}
		
		function Identify(address _id) returns(
		        uint timestamp,
		        bytes _name,
		        bytes32 _origin,
		        bytes32 _residency,
		        bytes32 _gender,
		        address _persona,
		        uint _birth,
		        uint _access,
		        int _exit,
		        int _status) {
		      
		      bytes memory name_id;
		      uint j = 0;
		    for(uint h = 0; name.length; h++) {
		        for(uint i = 0; name[h].length; i++) {
		            name_id[j] == name[h][i];
		            j++;
		        }
		        j++;
		    }
		    return now;
		    return name_id;
		    return origin;
		    return residency;
		    return gender;
		    return persona;
		    return diaspora;
		    return birth;
		    return access;
		    return exit;
		    return status;
	 
	        if(gender.male == true) {
	            gender = "Male";
	        } else if(gender.female == true) {
	            gender = "Female";
	        } return gender;
	        
		            
		        }
		
}
/*bytes32[] public name;
		bytes32 public id;
		bytes32 public origin;
		bytes32[] public residency;
		address public persona;
        address[] diaspora;
		uint public birth;
		uint public access;
		int public exit;
		int public status;
		Gender public gender;*/


       

