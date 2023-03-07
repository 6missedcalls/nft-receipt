// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function deployOracle() {
  const Oracle = await hre.ethers.getContractFactory("nft-oracle");
  const oracleDeployment = await Oracle.deploy();
  await oracleDeployment.deployed();

  const oracle = oracleDeployment.address;
  return oracle;
}

async function deployNft(address) {
  const nftContract = await hre.ethers.getContractFactory("nft-receipt");
  const deployedNft = await nftContract.deploy(address);
  await deployedNft.deployed();

  const nft = deployedNft.address;
  return nft;

}

async function main() {
  let oracle = deployOracle();
  let nft = deployNft(oracle);

  console.log(
    `Oracle ${oracle} | NFT ${nft}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
