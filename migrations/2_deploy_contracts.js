var Token = artifacts.require("./LBSCToken.sol");

Date.prototype.getUnixTime = function() { return this.getTime()/1000|0 };

module.exports = function(deployer, network, accounts) {
    let admin;

    console.log("Deploying contracts on: " + network);
    if (network=="development"){

        admin=accounts[1];

    }else if(network=="rinkeby"){

        admin="0xc1c13ed18081b6b1a9f6caa9e519cdc42b895c78";

    }else if(network=="mainnet"){

        admin="0x164d4534eb059f2674Af408e62Ee745381dF7929";
    
    }

    deployer.deploy(Token, admin);

};