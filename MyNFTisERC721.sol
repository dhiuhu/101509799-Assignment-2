// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract MyNFT is ERC721, Ownable {
    using SafeMath for uint256;

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {}

    struct NFT {
        string name;
        string metadataURI;
    }

    mapping(uint256 => NFT) private nfts;

    uint256 private tokenIdCounter = 1;

    
    function mintNFT(string memory _name, string memory _metadataURI) external onlyOwner {
        uint256 tokenId = tokenIdCounter;
        tokenIdCounter++;

        nfts[tokenId] = NFT({
            name: _name,
            metadataURI: _metadataURI
        });

        _mint(msg.sender, tokenId);
    }

    function transferOwnership(address _newOwner, uint256 _tokenId) external onlyOwner {
        require(_newOwner != address(0), "Invalid address");
        require(ownerOf(_tokenId) == msg.sender, "You don't own this NFT");

        _transfer(msg.sender, _newOwner, _tokenId);
    }

    function getNFT(uint256 _tokenId) external view returns (string memory, string memory) {
        NFT storage nft = nfts[_tokenId];
        require(bytes(nft.name).length > 0, "NFT does not exist");
        return (nft.name, nft.metadataURI);
    }
}
