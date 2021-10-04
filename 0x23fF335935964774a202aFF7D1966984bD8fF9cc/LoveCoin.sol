// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./BEP20.sol";

/*
        @@@@@@           @@@@@@
      @@@@@@@@@@       @@@@@@@@@@
    @@@@@@@@@@@@@@   @@@@@@@@@@@@@@
  @@@@@@@@@@@@@@@@@ @@@@@@@@@@@@@@@@@
 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
      @@@@@@@@@@@@@@@@@@@@@@@@@@@
        @@@@@@@@@@@@@@@@@@@@@@@
          @@@@@@@@@@@@@@@@@@@
            @@@@@@@@@@@@@@@
              @@@@@@@@@@@
                @@@@@@@
                  @@@
*/
contract LoveCoin is BEP20 {
    uint8 private constant DECIMALS = 8;
    uint public constant _totalSupply = 500000000000000 * 10**uint(DECIMALS);
    uint constant HALF_LIFE = 120 days;
    uint constant STARTING_SUPPLY = _totalSupply / 10; //1/10th of the supply is available at the start.
    uint private _lockedCoins = _totalSupply - STARTING_SUPPLY; //Inaccessible until sufficient time has passed (see releaseCoins())
    uint private _releasedCoins = STARTING_SUPPLY; //Released coins can be distributed by the admin via airdrop().
    uint private _releaseDate; //The time the contract was created.
    uint private _lastReleasePeriod; //The last time coins wer checked for release.

    address private _admin;
    address private _newAdmin;
    uint private _maxAirdrop = 10_000_000 * 10**DECIMALS; //The maximum amount an admin can airdrop at a single time. Used to prevent mistyping amounts.

    constructor() BEP20("Lovecoin Token", "Lovecoin") {
        _admin = msg.sender;
        _newAdmin = msg.sender;
        _releaseDate = block.timestamp;
    }

    function totalSupply() public view virtual override returns (uint) {
        return _totalSupply - _lockedCoins;
    }

    function maxSupply() public pure returns (uint) {
        return _totalSupply;
    }

    function decimals() public view virtual override returns (uint8) {
        return DECIMALS;
    }

    function editMaxAirdrop(uint newMax) public {
        require(msg.sender == _admin, "Admin address required.");
        _maxAirdrop = newMax * 10**DECIMALS;
    }

    //Allows the newAdmin address to claim the admin position. Two-step process to prevent mistyping the address.
    function editAdmin(address newAdmin) public {
        require(msg.sender == _admin, "Admin address required.");
        _newAdmin = newAdmin;
    }

    //If the calling address has been designated in the above editAdmin function, it will become the admin.
    //The old admin address will no longer have any admin priveleges.
    function claimAdmin() public {
        require(msg.sender == _newAdmin, "This address does not have the rights to claim the Admin position.");
        _admin = _newAdmin;
    }

    //Airdrops all given address the amount specified by the same index in the amounts array.
    //EX: addresses[4] receives amounts[4].
    function airdrop(address[] memory addresses, uint[] memory amounts) public {
        require(msg.sender == _admin, "Admin address required.");
        require(
            addresses.length == amounts.length,
            "Addresses and amounts arrays do not match in length."
        );
        for (uint i = 0; i < addresses.length; i++) {
            _airdrop(addresses[i], amounts[i] * 10**DECIMALS);
        }
    }

    function _airdrop(address recipient, uint amount) internal returns (bool) {
        require(amount <= _maxAirdrop, "Amount exceeds airdrop limit.");
        require(amount <= _releasedCoins, "Airdrop supply cannot cover the amount requested.");
        _releasedCoins -= amount;
        _mint(recipient, amount);
        return true;
    }

    //Tokens will be emitted at a rate of half the remaining supply every period.
    function releaseCoins() public {
        require(msg.sender == _admin, "Admin address required.");

        //HALF_LIFE is the duration of a period.
        uint currentPeriod = (block.timestamp - _releaseDate) / HALF_LIFE;
        require(currentPeriod > _lastReleasePeriod, "Already released coins this period.");

        uint toRelease;

        //If multiple periods have passed since a release, we need to release for those periods as well.
        uint periodsToRelease = currentPeriod - _lastReleasePeriod;

        for (uint i = 0; i < periodsToRelease; i++) {
            //Half of the remaining locked coins are released each period. 
            //'toRelease' is subtracted because we might be releasing for multiple periods, in which case we need
            //to factor in that amount.
            toRelease += (_lockedCoins - toRelease) / 2;
        }

        _lockedCoins -= toRelease;
        _releasedCoins += toRelease;
        _lastReleasePeriod = currentPeriod;
    }
}
