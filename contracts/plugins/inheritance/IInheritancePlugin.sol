// SPDX-License-Identifier: GPL3
pragma solidity ^0.8.19;

// Author: Francesco Sullo <francesco@sullo.co>

// erc165 interfaceId 0x8dca4bea
interface IInheritancePlugin {
  // @dev Emitted when a sentinel is updated
  event SentinelUpdated(address indexed owner, address indexed sentinel, bool status);

  event InheritanceConfigured(address indexed owner, uint256 quorum, uint256 proofOfLifeDurationInDays);

  event ProofOfLife(address indexed owner);

  event TransferRequested(address indexed sentinel, address indexed beneficiary);

  event TransferRequestApproved(address indexed sentinel);

  // @dev Emitted when a beneficiary inherits a token
  event InheritedBy(address indexed beneficiary);

  // @dev Struct to store the configuration for the inheritance
  struct InheritanceConf {
    uint256 quorum;
    uint256 proofOfLifeDurationInDays;
    uint256 lastProofOfLife;
  }

  // @dev Struct to store the request for a transfer to an heir
  struct InheritanceRequest {
    address beneficiary;
    uint256 startedAt;
    address[] approvers;
    // if there is a second thought about the recipient, the sentinel can change it
    // after the request is expired if not approved in the meantime
  }

  // beneficiaries

  // @dev Set a sentinel for the token
  // @param sentinel The sentinel address
  // @param active True to activate, false to deactivate
  // @param timestamp The timestamp of the signature
  // @param validFor The validity of the signature
  // @param signature The signature of the tokensOwner
  function setSentinel(address sentinel, bool active, uint256 timestamp, uint256 validFor, bytes calldata signature) external;

  // @dev Set a list of sentinels for the token
  //   It is a convenience function to set multiple sentinels at once, but it
  //   works only if no protectors have been set up. Useful for initial settings.
  // @param sentinels The sentinel addresses
  // @param emptySignature The signature of the tokensOwner
  //   It is needed to avoid compatibility with setSentinel which expect the
  //   signature coming as calldata
  function setSentinels(address[] memory sentinels, bytes calldata emptySignature) external;

  // @dev Configures an inheritance
  // @param quorum The number of sentinels required to approve a request
  // @param proofOfLifeDurationInDays The duration of the Proof-of-Live, i.e., the number
  //   of days after which the sentinels can start the process to inherit the token if the
  //   owner does not prove to be alive
  function configureInheritance(uint256 quorum, uint256 proofOfLifeDurationInDays) external;

  // @dev Return all the sentinels
  function getSentinelsAndInheritanceData()
    external
    view
    returns (address[] memory, InheritanceConf memory, InheritanceRequest memory);

  // @dev allows the user to trigger a Proof-of-Live
  function proofOfLife() external;

  // @dev Allows the sentinels to nominate a beneficiary
  // @param beneficiary The beneficiary address
  function requestTransfer(address beneficiary) external;

  // @dev Allows the beneficiary to inherit the token
  function inherit() external;
}