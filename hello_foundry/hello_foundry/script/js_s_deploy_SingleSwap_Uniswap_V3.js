const hre = require("hardhat");

async function main(){
    console.log(`deploying...`)

    const SingleSwap = await hre.ethers.getContractFactory("SingleSwap_Uniswap_V3")
    const _singleSwap = await SingleSwap.deploy(
        ""
    );

    await _singleSwap.deployed();

    console.log("Single Swap contract deployed:", _singleSwap.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode=1;
});