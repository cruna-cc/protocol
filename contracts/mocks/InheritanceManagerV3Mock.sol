// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {InheritancePlugin} from "../plugins/inheritance/InheritancePlugin.sol";

contract InheritancePluginV3Mock is InheritancePlugin {
  uint256 public constant SOME_VARIABLE = 3;
  bool public constant SOME_OTHER_VARIABLE = true;

  function version() public pure virtual override returns (uint256) {
    return 1e6 + 3;
  }

  // new function in V3
  function isMock() external pure returns (bool) {
    return true;
  }
}
