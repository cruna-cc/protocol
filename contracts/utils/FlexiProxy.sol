// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ERC6551AccountProxy} from "erc6551/examples/upgradeable/ERC6551AccountProxy.sol";
import {IFlexiProxy} from "./IFlexiProxy.sol";

// @dev This contract is a proxy for manager implementations.
//   Look at ERC6551AccountProxy for more details.
contract FlexiProxy is IFlexiProxy, ERC6551AccountProxy {
  bytes32 public proxyName;

  constructor(address _initialImplementation) ERC6551AccountProxy(_initialImplementation) {}

  // to avoid that we plug a non-proxy contract
  function isProxy() external pure returns (bool) {
    return true;
  }
}
