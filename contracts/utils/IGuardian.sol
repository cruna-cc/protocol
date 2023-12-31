// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

//import "hardhat/console.sol";

/**
 * @dev Manages upgrade and cross-chain execution settings for accounts
 */
interface IGuardian {
  event TrustedImplementationUpdated(bytes4 nameId, address implementation, bool trusted, uint256 requires);

  function setTrustedImplementation(bytes4 nameId, address implementation, bool trusted, uint256 requires) external;

  function trustedImplementation(bytes4 nameId, address implementation) external view returns (uint256);
}
