async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  // Replace with actual deployed flash loan provider and DEX addresses on Core Testnet 2
  const flashLoanProviderAddress = "0xYourFlashLoanProviderAddress";
  const dex1Address = "0xYourDEX1Address";
  const dex2Address = "0xYourDEX2Address";

  const FlashLoanArbitrage = await ethers.getContractFactory("FlashLoanArbitrage");
  const flashLoanArbitrage = await FlashLoanArbitrage.deploy(flashLoanProviderAddress, dex1Address, dex2Address);

  await flashLoanArbitrage.deployed();

  console.log("FlashLoanArbitrage deployed to:", flashLoanArbitrage.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
