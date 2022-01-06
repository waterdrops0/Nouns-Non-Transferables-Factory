// scripts/index.js
async function main () {
  // Send a transaction to store() a new value in the Box
    const address = '0xe7f1725e7734ce288f8367e1bb143e90bb3f0512';
    const CPPFactory1 = await ethers.getContractFactory('');
    const cppfactory = await CPPFactory1.attach(address);
    const tokenAddress = await cppfactory.createToken("CPPToken2", "CPPT2", 100);
    
    console.log("CPPT1 Token address is:", tokenAddress);
    
}

main()

  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });