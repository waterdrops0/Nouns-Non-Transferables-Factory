// scripts/deploy.js
async function main () {
    // We get the contract to deploy
    const Factory = await ethers.getContractFactory('NounishFactory');
    console.log('Deploying NounishFactory..');
    const factory = await Factory.deploy("0xe4b7125f3c6fa2692adf69e60d943f4fed492e23");
    await factory.deployed();
    console.log('NounishFactory deployed to:', factory.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error);
      process.exit(1);
    });