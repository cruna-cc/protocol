const { expect } = require("chai");
const { ethers } = require("hardhat");
const { toChecksumAddress } = require("ethereumjs-util");

let count = 9000;
function cl(...args) {
  console.log(count++, ...args);
}

const {
  amount,
  normalize,
  deployContractUpgradeable,
  addr0,
  getChainId,
  deployContract,
  getTimestamp,
  signRequest,
} = require("./helpers");

describe("Testing contract deployments", function () {
  let erc6551Registry, proxy, manager, guardian;
  let signatureValidator, vault;
  let factory;
  let usdc, usdt;
  let deployer, bob, alice, fred, mark, otto;
  let chainId, ts;

  before(async function () {
    [deployer, bob, alice, fred, mark, otto] = await ethers.getSigners();
    signatureValidator = await deployContract("SignatureValidator", "Cruna", "1");
    chainId = await getChainId();
  });

  beforeEach(async function () {
    erc6551Registry = await deployContract("ERC6551Registry");
    manager = await deployContract("Manager");
    guardian = await deployContract("Guardian", deployer.address);
    proxy = await deployContract("ManagerProxy", manager.address);

    vault = await deployContract(
      "CrunaFlexiVault",
      erc6551Registry.address,
      guardian.address,
      signatureValidator.address,
      proxy.address,
    );
    factory = await deployContractUpgradeable("VaultFactory", [vault.address]);

    await vault.setFactory(factory.address);

    usdc = await deployContract("USDCoin");
    usdt = await deployContract("TetherUSD");

    await usdc.mint(bob.address, normalize("900"));
    await usdt.mint(alice.address, normalize("600", 6));

    await expect(factory.setPrice(990)).to.emit(factory, "PriceSet").withArgs(990);
    await expect(factory.setStableCoin(usdc.address, true)).to.emit(factory, "StableCoinSet").withArgs(usdc.address, true);
    await expect(factory.setStableCoin(usdt.address, true)).to.emit(factory, "StableCoinSet").withArgs(usdt.address, true);
    ts = (await getTimestamp()) - 100;
  });

  const buyAVault = async (bob) => {
    const price = await factory.finalPrice(usdc.address, "");
    await usdc.connect(bob).approve(factory.address, price);
    const nextTokenId = await vault.nextTokenId();
    await factory.connect(bob).buyVaults(usdc.address, 1, "");
    return nextTokenId;
  };

  it("should deploy everything as expected", async function () {
    // test the beforeEach
  });

  it("should get the token parameters from the manager", async function () {
    let price = await factory.finalPrice(usdc.address, "");
    await usdc.connect(bob).approve(factory.address, price);
    const nextTokenId = await vault.nextTokenId();
    const managerAddress = await vault.managerOf(nextTokenId);
    expect(await ethers.provider.getCode(managerAddress)).equal("0x");
    await factory.connect(bob).buyVaults(usdc.address, 1, "");
    expect(await ethers.provider.getCode(managerAddress)).not.equal("0x");
    const manager = await ethers.getContractAt("Manager", managerAddress);
    expect(await manager.vault()).to.equal(vault.address);
    expect(await manager.tokenId()).to.equal(nextTokenId);
    expect(await manager.owner()).to.equal(bob.address);
  });
});