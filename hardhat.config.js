require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-web3");


task("balance", "Prints an account's balance")
  .addParam("account", "The account's address")
  .setAction(async (taskArgs) => {
    const account = web3.utils.toChecksumAddress(taskArgs.account);
    const balance = await web3.eth.getBalance(account);

    console.log(web3.utils.fromWei(balance, "ether"), "ETH");
    console.log(web3.utils.fromWei(balance, "CPPToken"), "CPPT");
    
    
  });


task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});



/**
 * @type import('hardhat/config').HardhatUserConfig
 */




const { infuraApiKey, mnemonic } = require('./secrets.json');



module.exports = {
  solidity: "0.8.9",
  
  networks: {
    rinkeby: {
      url: `https://rinkeby.infura.io/v3/${infuraApiKey}`,
      accounts: { mnemonic: mnemonic },
    },
  },
};

