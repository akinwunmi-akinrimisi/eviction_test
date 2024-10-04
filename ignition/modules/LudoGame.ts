const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LudoGameModule", (m) => {
  const ludoGame = m.contract("LudoGame", [], {});

  return { ludoGame };
});
