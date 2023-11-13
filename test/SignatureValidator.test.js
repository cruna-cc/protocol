const {expect} = require("chai");
const {ethers} = require("hardhat");
const DeployUtils = require("../scripts/lib/DeployUtils");
let deployUtils;
const helpers = require("./helpers");
const {getTimestamp} = require("./helpers");
const {domainType} = require("./helpers/eip712");
helpers.initEthers(ethers);
const {privateKeyByWallet, deployContract, getChainId, makeSignature} = helpers;

describe("SignatureValidator", function () {
  deployUtils = new DeployUtils(ethers);

  let chainId;

  let validator;
  let mailTo;
  let wallet;
  let protector;
  const name = "Cruna";
  const version = "1";

  before(async function () {
    [mailTo, wallet, tokenOwner, protector] = await ethers.getSigners();
    chainId = await getChainId();
  });

  beforeEach(async function () {
    validator = await deployContract("SignatureValidator", name, version);
  });

  it("should recover the signer of a recoverSigner", async function () {
    const message = {
      owner: tokenOwner.address,
      actor: protector.address,
      tokenId: 1,
      extraValue: 19928273,
      timestamp: (await getTimestamp()) - 100,
      validFor: 3600,
    };

    const signature = await makeSignature(
      chainId,
      validator.address,
      privateKeyByWallet[protector.address],
      "Auth",
      [
        {name: "owner", type: "address"},
        {name: "actor", type: "address"},
        {name: "tokenId", type: "uint256"},
        {name: "extraValue", type: "uint256"},
        {name: "timestamp", type: "uint256"},
        {name: "validFor", type: "uint256"},
      ],
      message
    );

    expect(
      await validator.recoverSigner(
        message.owner,
        message.actor,
        message.tokenId,
        message.extraValue,
        message.timestamp,
        message.validFor,
        signature
      )
    ).equal(protector.address);
  });
});