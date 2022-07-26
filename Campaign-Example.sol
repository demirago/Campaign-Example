//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Campaign {
// private:kontrat dışından göremeyiz. 
// uint e değer vermezsek default olarak uint256 oluyor.
//parasal değer default olarak wei olarak geliyor.
    
    address public owner;

    string public name ="test";
    string public description = "test";
    uint public minimumContrubution = 1000;

//Sürekli request oluşturabilmek için struct yapısını kullanıcaz.
    struct Request {
        string description;
        uint value;
        address receipent;
        bool isCompleted;
        uint approvalCount;
        mapping(address =>bool) approvals;
    } 

    Request[] public requests;



    mapping (address => bool) public contributors;

    uint public contributorsCount=0;

    // address[] contributor;

    event NewRequest(string description, uint value, address receipent);


    constructor (){
    // constructor (string memory _name, string memory _description, uint _minimumContrubition){

        owner=msg.sender;        
        //(name,description,minimumContrubion)=(_name,_description,_minimumContrubition);
        // name=_name;
        // description=_description;
        // minimumContrubion=_minimumContrubition;
    }

    modifier onlyOwner() {
        //do sth before function
        require (msg.sender == owner, "only owner");
        require (msg.sender == owner, "only owner");
        
        _;
        //do sth after function
    }


//contribute fonksiyonu ile bağış miktarı ve bağış yapanların listesini yapacağız. 
//if yerine require kullanılma sebebi gas tutarını geri vermesi.   
    function contribute () public payable {
        require(msg.value >= minimumContrubution,"Less then min Contribution");
        contributors[msg.sender] = true; 
        // require(contributor[msg.sender]==true,"alreadycontributed");
        contributorsCount++;

    }

//Requestleri array içinde tutacağız.
    function createRequest(string calldata _description, uint _value, address _receipent) public onlyOwner {
        Request storage newRequest = requests.push();
        newRequest.description=_description;
        newRequest.value=_value;
        newRequest.receipent=_receipent;

        emit NewRequest(_description,_value,_receipent);
    }
  
    function approveRequest (uint _index) public{
        require(contributors[msg.sender]==true,"not conributer"); 
        Request storage currentRequest = requests[_index];
        currentRequest.approvals[msg.sender]=true;
        currentRequest.approvalCount++;
        }
    function finalizeRequest (uint _index) public onlyOwner{ 
        Request storage currentRequest = requests[_index];
        require(!currentRequest.isCompleted,"already completed");
        require(currentRequest.approvalCount > (contributorsCount/2),"not enough approvals");
        currentRequest.isCompleted = true;

        payable (currentRequest.receipent).transfer(currentRequest.value);
        
 
    


    }
}