// SPDX-License-Identifier: GPL3
pragma solidity ^0.8.19;

// @dev This contract supports versions.
contract Versioned {
  // @dev This function will return the version of the contract.
  // @return The version of the contract as a string.
  function version() external pure virtual returns (string memory) {
    return "1.0.0";
  }
}
