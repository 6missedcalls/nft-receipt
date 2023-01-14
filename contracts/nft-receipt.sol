// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./nft-oracle.sol";

contract NFTReceipt is ERC721, ERC721Enumerable, ERC721URIStorage, ERC721Burnable, Ownable {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;
  NFTOracle public nftOracle;

  constructor(address _nftOracle) ERC721("NFT Receipt", "NFTRECEIPT") {
    nftOracle = NFTOracle(_nftOracle);
  }

  function mintReceipt(address _owner, uint256 _tokenId, string memory _name, string memory _description, string memory _imageURI) public onlyOwner {
    _tokenIds.increment();
    uint256 newItemId = _tokenIds.current();
    _mint(_owner, newItemId);
    _setTokenURI(newItemId, _imageURI);
    nftOracle.createReceipt(_owner, _tokenId, _name, _description, _imageURI);
  }

  function updateReceipt(uint256 _tokenId, string memory _name, string memory _description, string memory _imageURI) public onlyOwner {
    _setTokenURI(_tokenId, _imageURI);
    nftOracle.updateReceipt(ownerOf(_tokenId), _tokenId, _name, _description, _imageURI);
  }

  function deleteReceipt(uint256 _tokenId) public onlyOwner {
    _burn(_tokenId);
    nftOracle.deleteReceipt(ownerOf(_tokenId), _tokenId);
  }

  // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
  