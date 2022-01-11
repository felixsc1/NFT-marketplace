// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;
// Contract is based on this tutorial: https://www.youtube.com/watch?v=84j71K6wOCs

import "./IERC721.sol";

contract Market {
    enum ListingStatus {
        Active,
        Sold,
        Cancelled
    }

    struct Listing {
        ListingStatus status;
        address seller;
        address token;
        uint256 tokenId;
        uint256 price;
    }

    mapping(uint256 => Listing) private _listings;

    uint256 private _listingId;

    function listToken(
        address token,
        uint256 tokenId,
        uint256 price
    ) external {
        // important to first transfer the token to the contract, before creating the listing below.
        // if transfer fails we would otherwise have a listing to sell but no token.
        // in contrast, transferring things away should always come last.
        IERC721(token).transferFrom(msg.sender, address[this], tokenId);

        // memory means this variable will be deleted after the function call.
        Listing memory listing = Listing(
            ListingStatus.Active,
            msg.sender,
            token,
            tokenId,
            price
        );

        // to store the data permanently, we add it to the mapping.
        // state variables are always stored in storage.
        _listingId++;
        _listings[_listingId] = listing;
    }

    function buyToken(uint256 listingId) external payable {
        // here using storage will create a pointer to the _listings mapping above.
        // every change to the "listing" variable will thus be updated on storage. with "memory" they would not be permanent.
        // see video 14:50
        Listing storage listing = _listings(listingId);

        require(msg.sender != listing.seller, "Seller cannot be buyer");
        require(
            listing.status == ListingStatus.Active,
            "Listing is not active"
        );
        require(msg.value >= listing.price, "Insufficient payment");

        // Here, important to transfer funds only after the token could be transferred.
        // Always expect external calls to fail.
        IERC721(listing.token).transferFrom(address[this], msg.sender, tokenId);
        payable(listing.seller).transfer(listing.price);

        listing.status = ListingStatus.Sold;
    }

    function cancel(uint256 listingId) public {
        Listing storage listing = _listings(listingId);
        require(listing.seller == msg.sender, "You are not the seller");
        require(
            listing.status == Listing.status.Active,
            "Listing is not active"
        );

        IERC721(listing.token).transferFrom(address[this], msg.sender, tokenId);
        // Here I disagree with video, if we update status before attempting to transfer..
        // if it fails, seller could not re-try the function and token would be stuck in contract.
        listing.status = ListingStatus.Cancelled;
    }
}
