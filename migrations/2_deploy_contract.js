const DeadManSwitch = artifacts.require("DeadManSwitch");

module.exports = function (deployer) {
    deployer.deploy(DeadManSwitch, "0x29D9C4405A72ffa26eB13218b7C29F98F2B21aD0");
};
