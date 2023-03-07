// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract NFTOracle {
  // we will first define a struct to hold the data we want to store
  struct Receipt {
    address owner;  // the owner of the product
    address seller;  // the seller of the product (cannot be changed after creation)
    uint256 tokenId;  // the token id of the product (will be used for lookup in oracle)
    string name;  // the name of the product
    string description;  // the description of the product
    string imageURI; // the image URI of the product
  }

  struct Account {
    address accountAddress;
    string name;
  }

  // we will then define a mapping to store the data
  mapping(address => Account) public accounts;
  mapping(address => Receipt[]) public receipts;

  // we will then define a crud functions for the data
  function createAccount(string memory _name) public {
    accounts[msg.sender] = Account(msg.sender, _name);
  }

  function createReceipt(address _owner, uint256 _tokenId, string memory _name, string memory _description, string memory _imageURI) public {
    receipts[_owner].push(Receipt(_owner, msg.sender, _tokenId, _name, _description, _imageURI));
  }

  function readReceipt(address _owner, uint256 _index) public view returns (Receipt memory) {
    require(msg.sender == _owner, "Error: You are not the owner of this receipt");
    return receipts[_owner][_index];
  }

  function updateReceipt(address _owner, uint256 _index, string memory _name, string memory _description, string memory _imageURI) public {
    require(msg.sender == _owner || msg.sender == receipts[_owner][_index].seller, "Error: You are not the owner or seller of this receipt");
    Receipt storage receipt = receipts[_owner][_index];
    receipt.name = _name;
    receipt.description = _description;
    receipt.imageURI = _imageURI;
  }

  function deleteReceipt(address _owner, uint256 _index) public {
    require(msg.sender == _owner || msg.sender == receipts[_owner][_index].seller, "Error: You are not the owner or seller of this receipt");
    delete receipts[_owner][_index];
  }

  function getReceiptsLength(address _owner) public view returns (uint256) {
    require(msg.sender == _owner, "Error: You are not the owner of this receipt");
    return receipts[_owner].length;
  }

  function getAccount(address _accountAddress) public view returns (Account memory) {
    return accounts[_accountAddress];
  }
}
