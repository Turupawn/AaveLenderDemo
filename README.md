![test workflow](https://github.com/Turupawn/AaveLenderDemo/actions/workflows/test.yml/badge.svg)

# Aave Lender Demo

Smart contract that lends on Aave and collects yield. The code can be used as an example to earn passively on presales, auctions, dao treasuries or any contract that holds idle ERC20 tokens.

## Running the test

The testing script lends DAI and Aave on Scroll Sepolia. Run it the following way:

```bash
forge test --fork-url https://sepolia-rpc.scroll.io/
```