# NFT Marketplace test

Based on [this video tutorial](https://www.youtube.com/watch?v=84j71K6wOCs).

## Functionality

*Market.sol* is a contract on which anyone can sell ERC721 tokens.
Seller can list a token via listToken(), providing the address of the token contract, tokenId and price (Ethereum).
Any change on the state is emitted as event.