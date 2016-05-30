/// @title Utilities 0.1.
/// @author Physes

contract Utilities {
    
    function toChar(uint input) internal returns (uint output) {
        if(input > 9) 
            return input + 87;
        else
            return input + 48;
    }
    
    //translate an input of type address to type bytes

    function addressToBytes(address input) internal returns(bytes output) {
        uint160 addresses = uint160(input);
        
        string memory holder = "                                        ";
        bytes memory _output = bytes(holder);
        
        uint counter = 0;
        for(uint a = 0; a < 20; a++) {
            uint _addresses = addresses / (2 ** (8 * (19 - a)));
            uint _bytesA = (_addresses / 0x10) & 0x0f;
            uint _bytesB = _addresses & 0x0f;
            _output[counter++] = byte(toChar(_bytesA));
            _output[counter++] = byte(toChar(_bytesB));
        }
        return _output;
    }
    
    //translate an input of type bytes to type bytes32

    function bytes32ToBytes(bytes32 input) internal returns(bytes output) {
        uint letters = uint(input);
        string memory holder = new string(64);
        bytes memory _output = bytes(holder);
        
        uint counter;
        
        for(uint b = 0; b < 32; b++) {
            uint _letters = letters / (2 ** (8 * (31 - b)));
            uint _bytesA = (_letters / 0x10) & 0x0f;
            uint _bytesB = _letters & 0x0f;
            _output[counter++] = byte(toChar(_bytesA));
            _output[counter++] = byte(toChar(_bytesB));
        }
        return _output;
    }
    
    //translate an input of type bytes32 to type string

    function bytes32ToString (bytes32 input) returns (string output) {
        bytes memory _letters = new bytes(32);
        for (uint c = 0; c < 32; c++) {
            byte char = byte(bytes32(uint(input) * 2 ** (8 * c)));
            if (char != 0) {
                _letters[c] = char;
            }
        }
        return string(_letters);
    }

    //translate an input of type bytes32 Array to a string

    function bytes32ArrayToString (bytes32[] input) returns (string output) {
        bytes memory _words = new bytes(input.length * 32);
        uint length;
        
        for (uint d = 0; d < input.length; d++) {
            for (uint e = 0; e < 32; e++) {
                byte _letter = byte(bytes32(uint(input[d]) * 2 ** (8 * e)));
                if (_letter != 0) {
                    _words[length] = _letter;
                    length += 1;
                }
            }
        }
        bytes memory _output = new bytes(length);
        
        for (uint f = 0; f < length; f++) {
            _output[f] = _words[f];
        }
        return string(_output);
    }
    
    //translate a PaxID to a printable string
    
    function paxIdToString(bytes32 input) internal returns (string output) {
        return string(bytes32ToBytes(input));
    }
    
}