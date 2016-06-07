/// @title Org 0.1.
/// @author Physes, 2016

/* This is a contract for creating organizations which feature an interchangeable manager
and members, who pay a subscription fee on an interval basis for continued membership.
The interval is defined by the Org creation function- this could be a 1 week, 1 month, 2 months
1 year etc, represented in Unix time format. Each organization can have members, who pay
both an entrance fee to join and an ongoing subscription for continued membership.
It is up to the leader of the organization to call the "Process" function at the right time. The 
Process function detects if all the members have paid their subscription fee before 
the "lastDate", and if not removes their name from the list (if this is a mistake, 
the member in question can always rejoin). The first third of every interval is reserved 
so that the Leader can call the Process() function; during this interval members are 
also blocked from paying their subscription.  */ 

contract Org {

    /// @param the address of the overall owner
    
    address owner;
    
    /// @dev a struct for each member of the Org
    /// @param "bool paid" is set to true when the subscription 
    /// is paid within a billing interval
    
    struct Member {
        bytes32 name;
        address id;
        bool paid;
    }
    
    /// @param the expense struct keeps track of Org expenses in a way that 
    /// is complete auditable by anyone within the Org
    
    struct Expense {
        bytes32 description;
        uint amount;
        uint date;
    }
    
    /// @dev the central data structure for each individual org
    /// @param name: the name of the org
    /// @param orgMembers: a dynamic array for querying all members of type Member
    /// @param created: the timestamp of org creation, used for calculating intervals
    /// @param entranceFee: the rate the leader sets upfront for entry (can be set to zero)
    /// @param subscription: the rate of ongoing subscription for the defined interval
    /// @param interval: the time interval for subscriptions (i.e. weekly, monthly etc)
    /// @param memberNum: the number of members in the org
    /// @param txNum: the number of transactions made by the leader
    /// @param funds: the amount of money associated with the Org
    /// @param expenses mapping: mapping an ever increasing number with a new expense object
    /// @param members mapping: mapping an ever increasing number with a new member object
    
    struct org {
        bytes32 name;
        bytes32[] orgMembers;
        uint created;
        address leader;
        uint entranceFee;
        uint subscription;
        uint interval;
        uint lastDate;
        uint memberNum;
        uint txNum;
        uint funds;
        mapping(uint => Expense) expenses;
        mapping(uint => Member) members;
    }
    
    /// @param a counter which keeps track of how many orgs
    /// @param a mapping which holds new orgs relative to their orgNum (uint)
    
    uint orgNum;
    mapping(uint => org) orgs;
    
    // the constructor, sets the owner to whoever initiates the contract
    
    function Org() {
        owner = msg.sender;
    }
    
    
    modifier onlyOwner {
        if(owner != msg.sender) throw;
        _
    }
    
    modifier onlyLeader(uint _orgNum) {
        if(orgs[_orgNum].leader != msg.sender) throw;
        _
    }
    
    modifier onlyMember(uint _orgNum, uint _memberNum) {
        if(msg.sender != orgs[_orgNum].members[_memberNum].id) throw;
        _
    }
    
    modifier onlyOrg(uint _orgNum, uint _memberNum) {
        if(orgs[_orgNum].leader != msg.sender ||
        orgs[_orgNum].members[_memberNum].id != msg.sender) throw;
        _
    }
    
    event Transaction(uint _orgNum, address _to, uint time);
    event Broadcast(uint indexed _orgNum, uint indexed _memberNum, uint indexed time);
    
    
    function createOrganization(bytes32 _name,
                                uint _entranceFee, 
                                uint _subscription, 
                                uint _interval) onlyOwner returns (uint orgNum) {
        orgs[orgNum].name = _name;
        orgs[orgNum].created = now;
        orgs[orgNum].leader = msg.sender;
        orgs[orgNum].entranceFee = _entranceFee;
        orgs[orgNum].subscription = _subscription;
        orgs[orgNum].interval = _interval;
        orgs[orgNum].txNum = 0;
        
        
        Broadcast(orgNum, 0, now);
        return orgNum;
        
        orgNum++;
    }
    
    function deleteOrganization(uint _orgNum) onlyLeader(_orgNum) returns (bool success) {
        delete(orgs[_orgNum]);
        return true;
    }
    
    function transferLeader(uint _orgNum, address newOwner) onlyLeader(_orgNum) returns (bool success) {
        orgs[_orgNum].leader = newOwner;
        return true;
    }
    
    function becomeMember(uint _orgNum, bytes32 _name) returns (uint _memberNum) {
        
        if(msg.value >= orgs[_orgNum].entranceFee) {
            uint a = orgs[_orgNum].memberNum;
            orgs[_orgNum].members[a].name = _name;
            orgs[_orgNum].members[a].id = msg.sender;
            orgs[_orgNum].orgMembers.push(_name);
        }
        return a;
        a += 1;
    }
    
    function memberLeave(uint _orgNum, uint _memberNum) 
                        onlyMember(_orgNum, _memberNum) returns (bool success) {
        
        var orgMembers = orgs[_orgNum].orgMembers;
                            
        delete(orgs[_orgNum].members[_memberNum]);
        delete(orgMembers[_memberNum]);
      
        return true;
    }
    
    function removeMember(uint _orgNum, uint _memberNum) 
                        onlyLeader(_orgNum) returns (bool success) {
        
        var orgMembers = orgs[_orgNum].orgMembers;                    
                            
        delete(orgs[_orgNum].members[_memberNum]);
        delete(orgMembers[_memberNum]);
        
        return true;
    }
    
    function Process(uint _orgNum) 
                        onlyLeader(_orgNum) returns (bool success) {
        uint created = orgs[_orgNum].created;
        uint interval = orgs[_orgNum].interval;
        uint lastDate = orgs[_orgNum].lastDate;
        uint memberNum = orgs[_orgNum].memberNum;
        
        if(now < created + interval) {
            lastDate = created;
        }
        
        if(now < lastDate + interval/3) {
            for(uint b = 0; b < orgs[_orgNum].memberNum; b++) {
                orgs[_orgNum].members[b].paid = false;
            }
        }
        
        if(now > lastDate + interval) {
            for(uint c = 0; c < orgs[_orgNum].memberNum; c++) {
                if(orgs[_orgNum].members[c].paid = false) {
                    removeMember(_orgNum, c);
                }
            }
            lastDate = lastDate + interval;
        }
        return true;
    }
    
    function paySubscription(uint _orgNum, uint _memberNum) 
                            onlyMember(_orgNum, _memberNum) returns (bool success) {
        uint subscription = orgs[_orgNum].subscription;
        uint lastDate = orgs[_orgNum].lastDate;
        uint interval = orgs[_orgNum].interval;
        
        if(now < lastDate + interval/3 || msg.value < subscription) 
            throw;
        else {
            orgs[_orgNum].funds += msg.value;
            orgs[_orgNum].members[_memberNum].paid = true;
        }
        return true;
    }
    
    function listMembers(uint _orgNum) returns (bytes32[] output) {
        return orgs[_orgNum].orgMembers;
    }
    
    function transaction(bytes32 _description, uint _amount, address _to, uint _orgNum)
                            onlyLeader(_orgNum) returns (bool success) {
        _amount = msg.value;
        uint txNum = orgs[_orgNum].txNum;
        if(orgs[_orgNum].funds > _amount) {
            orgs[_orgNum].funds -= _amount;
            _to.send(_amount);
        }
        
        orgs[_orgNum].expenses[txNum].description = _description;
        orgs[_orgNum].expenses[txNum].amount = _amount;
        orgs[_orgNum].expenses[txNum].date = now;
        orgs[_orgNum].txNum++;
        
        return true;               
    }
    
    function queryTransaction(uint _orgNum, uint _txHistory) 
                            returns (uint[] output) {
            uint[] _output;
            
            _output.push(orgs[_orgNum].expenses[_txHistory].amount);
            _output.push(orgs[_orgNum].expenses[_txHistory].date);
            
            return _output;
            
        }
    
    function suicide() onlyOwner {
        selfdestruct(msg.sender);
    }
        
    
  
}
