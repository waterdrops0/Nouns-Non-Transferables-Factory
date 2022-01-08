import { ethers } from "hardhat";

async function main() {

  const NounishFactory = await ethers.getContractFactory("NounishFactory");
  const NounishFactoryReceipt = await NounishFactory.deploy("0xe4b7125f3c6fa2692adf69e60d943f4fed492e23");
  await NounishFactoryReceipt.deployed();


  console.log({
    NounishFactory: NounishFactoryReceipt.address
  });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});