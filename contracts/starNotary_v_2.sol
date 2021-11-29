// SPDX-License-Identifier: MIT
pragma solidity >=0.4.24;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';

contract StarNotary is ERC721 {


    struct Star{
        string name;
    }

    // Implement Task 1 Add a name and symbol properties
    // name: Is a short name to your token
    // symbol: Is a short string like 'USD' -> 'American Dollar'

   constructor() ERC721(name(),symbol()){
    }

    function name() public pure override returns (string memory) {
        return "Star Token";
    }
     function symbol() public pure override returns (string memory) {
        return "SNT";
    }
    function totalSupply() external pure returns (uint256){
          return 100;
    }

    mapping(uint256 => Star) public tokenIdToStarInfo;
    mapping(uint256 => uint256) public starsForSale;

    function createStar(string memory _name, uint256 _tokenId) public{
        Star memory newStar = Star(_name);
        tokenIdToStarInfo[_tokenId] = newStar;
        _mint(msg.sender, _tokenId);
    }

    function putStarUpForSale(uint256 _tokenId, uint256 _price) public{
        require(ownerOf(_tokenId) == msg.sender, "You can't sell a Star you don't own");
        starsForSale[_tokenId] = _price;
    }

    function _make_payable(address x) internal pure returns (address payable){
        return payable(address(uint160(x)));
    }

    function buyStar(uint256 _tokenId) public payable{
        require(starsForSale[_tokenId] > 0, "The Star should be up for sale!");
        uint256 starCost = starsForSale[_tokenId];
        address ownerAddress = ownerOf(_tokenId);
        require(msg.value > starCost, "You don't have enough Ether");
        transferFrom(ownerAddress, msg.sender, _tokenId);
        address payable ownerAddressPayable = _make_payable(ownerAddress);
        ownerAddressPayable.transfer(starCost);
        if(msg.value > starCost){
            payable(msg.sender).transfer(msg.value - starCost);
        }

    }
    

     // Implement Task 1 lookUptokenIdToStarInfo
    function lookUptokenIdToStarInfo (uint _tokenId) public view returns (string memory) {
        //1. You should return the Star saved in tokenIdToStarInfo mapping
        Star memory starName = tokenIdToStarInfo[_tokenId];
        return starName.name;
         
    }

    // Implement Task 1 Exchange Stars function
    function exchangeStars(uint256 _tokenId1, uint256 _tokenId2) public {
        //1. Passing to star tokenId you will need to check if the owner of _tokenId1 or _tokenId2 is the sender
         //3. Get the owner of the two tokens (ownerOf(_tokenId1), ownerOf(_tokenId1)
        if(ownerOf(_tokenId1) == msg.sender && ownerOf(_tokenId2) == msg.sender){
            //4. Use _transferFrom function to exchange the tokens.
        transferFrom(ownerOf(_tokenId1), ownerOf(_tokenId2), _tokenId1);
        transferFrom(ownerOf(_tokenId2), ownerOf(_tokenId1), _tokenId2);

        }
        
    }

    // Implement Task 1 Transfer Stars
    function transferStar(address _to1, uint256 _tokenId) public {
        //1. Check if the sender is the ownerOf(_tokenId)
        if(msg.sender == ownerOf(_tokenId)){
             //2. Use the transferFrom(from, to, tokenId); function to transfer the Star
            transferFrom(ownerOf(_tokenId), _to1, _tokenId);
        }
       
    }
}
