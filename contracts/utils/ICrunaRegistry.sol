// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// Modified registry based on CrunaRegistry
// https://github.com/erc6551/reference/blob/main/src/CrunaRegistry.sol

// We deploy our own registry to avoid misleading observers that may believe
// that managers and plugins are accounts.

// import "hardhat/console.sol";

interface ICrunaRegistry {
  /**
   * @dev The registry MUST emit the ERC6551AccountCreated event upon successful account creation.
   */
  event BoundContractCreated(
    address contractAddress,
    address indexed implementation,
    bytes32 salt,
    uint256 chainId,
    address indexed tokenContract,
    uint256 indexed tokenId
  );

  /**
   * @dev Creates a token bound account for a non-fungible token.
   *
   * If account has already been created, returns the account address without calling create2.
   *
   * Emits ERC6551AccountCreated event.
   *
   * @return account The address of the token bound account
   */
  function createBoundContract(
    address implementation,
    bytes32 salt,
    uint256 chainId,
    address tokenContract,
    uint256 tokenId
  ) external returns (address account);

  /**
   * @dev Returns the computed token bound account address for a non-fungible token.
   *
   * @return account The address of the token bound account
   */
  function boundContract(
    address implementation,
    bytes32 salt,
    uint256 chainId,
    address tokenContract,
    uint256 tokenId
  ) external view returns (address account);
}
