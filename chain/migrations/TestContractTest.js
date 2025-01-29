const { expect } = require("chai");

describe("TestContract", function () {
  let TestContract;
  let testContract;

  beforeEach(async function () {
    TestContract = await ethers.getContractFactory("TestContract");
    testContract = await TestContract.deploy();
    await testContract.deployed();
  });

  it("should set and get the value correctly", async function () {
    await testContract.setValue(42);
    expect(await testContract.getValue()).to.equal(42);
  });

  it("should emit ValueChanged event on setValue", async function () {
    await expect(testContract.setValue(42))
      .to.emit(testContract, "ValueChanged")
      .withArgs(42);
  });
});
