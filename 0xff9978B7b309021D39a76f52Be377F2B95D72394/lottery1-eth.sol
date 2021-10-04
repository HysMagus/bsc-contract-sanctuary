/* Copyright (C) 1991-2020 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, see
   <https://www.gnu.org/licenses/>.  */
/* This header is separate from features.h so that the compiler can
   include it implicitly at the start of every compilation.  It must
   not itself include <features.h> or any other header that includes
   <features.h> because the implicit include comes before any feature
   test macros that may be defined in a source file before it first
   explicitly includes a system header.  GCC knows the name of this
   header in order to preinclude it.  */
/* glibc's intent is to support the IEC 559 math functionality, real
   and complex.  If the GCC (4.9 and later) predefined macros
   specifying compiler intent are available, use them to determine
   whether the overall intent is to support these features; otherwise,
   presume an older compiler has intent to support these features and
   define these macros by default.  */
/* wchar_t uses Unicode 10.0.0.  Version 10.0 of the Unicode Standard is
   synchronized with ISO/IEC 10646:2017, fifth edition, plus
   the following additions from Amendment 1 to the fifth edition:
   - 56 emoji characters
   - 285 hentaigana
   - 3 additional Zanabazar Square characters */
/* Orchid - WebRTC P2P VPN Market (on Ethereum)
 * Copyright (C) 2017-2020  The Orchid Authors
*/
/* GNU Affero General Public License, Version 3 {{{ */
/* SPDX-License-Identifier: AGPL-3.0-or-later */
/*
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.

 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
**/
/* }}} */
pragma solidity 0.7.2;
pragma experimental ABIEncoderV2;
contract OrchidLottery1eth {
    struct Pot {
        uint256 escrow_amount_;
        uint256 unlock_warned_;
    }
    event Create(address indexed funder, address indexed signer );
    event Update(address indexed funder, address indexed signer );
    event Delete(address indexed funder, address indexed signer );
    struct Lottery {
        mapping(address => Pot) pots_;
        uint256 bound_;
        mapping(address => uint256) recipients_;
    }
    mapping(address => Lottery) private lotteries_;
    function read(address funder, address signer, address recipient ) external view returns (uint256, uint256, uint256) {
        Lottery storage lottery = lotteries_[funder];
        Pot storage pot = lottery.pots_[signer];
        return (pot.escrow_amount_, pot.unlock_warned_, lottery.bound_ << 128 | lottery.recipients_[recipient]);
    }
    receive() external payable {
        { Pot storage pot = lotteries_[msg.sender].pots_[msg.sender]; uint256 cache = pot.escrow_amount_; require(uint128(cache) + msg.value >> 128 == 0); pot.escrow_amount_ = cache + msg.value; }
    }
    function gift(address funder, address signer) external payable {
        { Pot storage pot = lotteries_[funder].pots_[signer]; uint256 cache = pot.escrow_amount_; require(uint128(cache) + msg.value >> 128 == 0); pot.escrow_amount_ = cache + msg.value; }
    }
    function move(address signer, uint256 adjust_retrieve) external payable {
        address payable funder = msg.sender;
        uint256 amount = msg.value;
        Pot storage pot = lotteries_[funder].pots_[signer];
        uint256 escrow = pot.escrow_amount_;
        amount += uint128(escrow);
        escrow = escrow >> 128;
    {
        bool create;
        int256 adjust = int256(adjust_retrieve) >> 128;
        if (adjust < 0) {
            uint256 warned = pot.unlock_warned_;
            uint256 unlock = warned >> 128;
            warned = uint128(warned);
            uint256 recover = uint256(-adjust);
            require(recover <= escrow);
            amount += recover;
            escrow -= recover;
            require(recover <= warned);
            require(unlock - 1 < block.timestamp);
            pot.unlock_warned_ = (warned - recover == 0 ? 0 : unlock << 128 | warned - recover);
        } else if (adjust != 0) {
            if (escrow == 0)
                create = true;
            uint256 transfer = uint256(adjust);
            require(transfer <= amount);
            amount -= transfer;
            escrow += transfer;
        }
        if (create)
            emit Create(funder, signer );
        else
            emit Update(funder, signer );
    }
        uint256 retrieve = uint128(adjust_retrieve);
        if (retrieve != 0) {
            require(retrieve <= amount);
            amount -= retrieve;
        }
        require(amount < 1 << 128);
        require(escrow < 1 << 128);
        pot.escrow_amount_ = escrow << 128 | amount;
        if (retrieve != 0)
            { (bool _s,) = funder.call{value: retrieve}(""); require(_s); }
    }
    function warn(address signer , uint128 warned) external {
        Pot storage pot = lotteries_[msg.sender].pots_[signer];
        pot.unlock_warned_ = (warned == 0 ? 0 : (block.timestamp + 1 days) << 128 | warned);
        emit Update(msg.sender, signer );
    }
    event Bound(address indexed funder);
    function bind(bool allow, address[] calldata recipients) external {
        Lottery storage lottery = lotteries_[msg.sender];
        uint i = recipients.length;
        if (i == 0)
            lottery.bound_ = allow ? 0 : (block.timestamp + 1 days);
        else {
            uint256 value = allow ? uint256(-1) :
                lottery.bound_ < block.timestamp ? 0 : (block.timestamp + 1 days);
            do lottery.recipients_[recipients[--i]] = value;
            while (i != 0);
        }
        emit Bound(msg.sender);
    }
    /*struct Track {
        uint96 expire;
        address owner;
    }*/
    struct Track {
        uint256 packed;
    }
    mapping(bytes32 => Track) private tracks_;
    function save(uint256 count, bytes32 seed) external {
        for (seed = keccak256(abi.encode(seed, msg.sender));; seed = keccak256(abi.encode(seed))) {
            tracks_[seed].packed = uint256(msg.sender);
            if (count-- == 0)
                break;
        }
    }
    /*struct Ticket {
        uint128 reveal;
        uint128 nonce;

        uint64 issued;
        uint64 ratio;
        uint128 amount;

        uint63 expire;
        address funder;
        uint32 salt;
        uint1 v;

        bytes32 r;
        bytes32 s;
    }*/
    struct Ticket {
        uint256 packed0;
        uint256 packed1;
        uint256 packed2;
        bytes32 r;
        bytes32 s;
    }
    function claim_(
        uint256 destination,
        Ticket calldata ticket
       
    ) private returns (uint256) {
        uint256 issued = (ticket.packed1 >> 192);
        uint256 expire = issued + (ticket.packed2 >> 193);
        if (expire <= block.timestamp)
            return 0;
        bytes32 digest; assembly { digest := chainid() } digest = keccak256(abi.encode(keccak256(abi.encode(keccak256(abi.encode(ticket.packed0 >> 128, destination)), uint32(ticket.packed2 >> 1))), uint128(ticket.packed0), ticket.packed1, ticket.packed2 & ~uint256(0x1ffffffff) , this, digest));
        address signer = ecrecover(digest, uint8((ticket.packed2 & 1) + 27), ticket.r, ticket.s);
        if (uint64(ticket.packed1 >> 128) < uint64(uint256(keccak256(abi.encode(ticket.packed0, issued)))))
            return 0;
        uint256 amount = uint128(ticket.packed1);
        address funder = address(ticket.packed2 >> 33);
        Lottery storage lottery = lotteries_[funder];
        if (lottery.bound_ - 1 < block.timestamp)
            if (lottery.recipients_[address(destination)] <= block.timestamp)
                return 0;
    {
        Track storage track = tracks_[bytes32(uint256(signer)) ^ digest];
        if (track.packed != 0)
            return 0;
        track.packed = expire << 160 | uint256(msg.sender);
    }
        Pot storage pot = lottery.pots_[signer];
        uint256 cache = pot.escrow_amount_;
        if (uint128(cache) >= amount) {
            emit Update(funder, signer );
            pot.escrow_amount_ = cache - amount;
            return amount;
        } else {
            emit Delete(funder, signer );
            pot.escrow_amount_ = 0;
            return uint128(cache);
        }
    }
    /*struct Destination {
        uint1 direct;
        uint95 pepper;
        address recipient;
    }*/
    function claimN(bytes32[] calldata refunds, uint256 destination, Ticket[] calldata tickets ) external {
        address payable recipient = address(destination); if (recipient == address(0)) destination |= uint256(recipient = msg.sender);
        for (uint256 i = refunds.length; i != 0; )
            { Track storage track = tracks_[refunds[--i]]; uint256 packed = track.packed; if (packed >> 160 <= block.timestamp) if (address(packed) == msg.sender) delete track.packed; }
        uint256 segment; assembly { segment := mload(0x40) }
        uint256 amount = 0;
        for (uint256 i = tickets.length; i != 0; ) {
            amount += claim_(destination, tickets[--i] );
            assembly { mstore(0x40, segment) }
        }
        if (amount == 0) {} else if (destination >> 255 == 0) { (bool _s,) = recipient.call{value: amount}(""); require(_s); } else { Pot storage pot = lotteries_[recipient].pots_[recipient]; uint256 cache = pot.escrow_amount_; require(uint128(cache) + amount >> 128 == 0); pot.escrow_amount_ = cache + amount; }
    }
    function claim1(bytes32 refund, uint256 destination, Ticket calldata ticket ) external {
        address payable recipient = address(destination); if (recipient == address(0)) destination |= uint256(recipient = msg.sender);
        if (refund != 0)
            { Track storage track = tracks_[refund]; uint256 packed = track.packed; if (packed >> 160 <= block.timestamp) if (address(packed) == msg.sender) delete track.packed; }
        uint256 amount = claim_(destination, ticket );
        if (amount == 0) {} else if (destination >> 255 == 0) { (bool _s,) = recipient.call{value: amount}(""); require(_s); } else { Pot storage pot = lotteries_[recipient].pots_[recipient]; uint256 cache = pot.escrow_amount_; require(uint128(cache) + amount >> 128 == 0); pot.escrow_amount_ = cache + amount; }
    }
}
