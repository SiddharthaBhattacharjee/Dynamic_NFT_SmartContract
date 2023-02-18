//SPDX-License-Identifier: unlicense
pragma solidity ^0.8.4;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract SimpleMintContract is ERC721, Ownable{
    uint256 public mintPrice = 0.05 ether;
    uint256 public totalSupply;
    uint256 public maxSupply;
    bool public isMintEnabled;
    mapping(address => uint256) public mintedWallets;
    mapping (uint256 => string) private _tokenData;

    constructor() payable ERC721('Simple Mint','SM'){
        maxSupply = 2;
    }

    function toggleIsMintEnaled() external onlyOwner {
        isMintEnabled = !isMintEnabled;
    }
    
    function setMaxSupply(uint256 maxSupply_) external onlyOwner{
        maxSupply = maxSupply_;
    }

    function mint() external payable{
        require(isMintEnabled,"Minting Not Enabled");
        require(mintedWallets[msg.sender] < 1, "Exceeds max per wallet");
        require(msg.value <= mintPrice, "Wrong Value");
        require(maxSupply > totalSupply, "Sold Out");

        mintedWallets[msg.sender]++;
        totalSupply++;
        uint256 tokenId = totalSupply;
        _safeMint(msg.sender, tokenId);
        _tokenData[tokenId] = "Place Holder Data";
    }

    function setTokenData(uint256 tokenId, string memory data) public onlyOwner {
        require(_exists(tokenId), "Token does not exist");
        _tokenData[tokenId] = data;
    }

    function tokenData(uint256 tokenId) public view returns (string memory) {
        require(_exists(tokenId), "Token does not exist");
        return _tokenData[tokenId];
    }

    function verifyOwnership(uint256 tokenId) external view returns (bool) {
        return _exists(tokenId) && ownerOf(tokenId) == msg.sender;
    }

    function getOwnedTokenId() public view returns (uint256) {
        require(balanceOf(msg.sender) == 1, "Sender does not own exactly 1 token");
        for(uint i=1;i<=totalSupply;i++){
            if(ownerOf(i)==msg.sender){
                return i;
            }
        }
    }

}