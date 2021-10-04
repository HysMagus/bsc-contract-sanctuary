// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IBDBattle
{
	function authAddress() external view returns (address);
	function holdingAddress() external view returns (address);
	function dcToken() external view returns (address);
	function bdtToken() external view returns (address);

	// uint256 public entryFee = 2e18;
	// uint256 public winAmountDC = 4e18;
	// uint256 public lossAmountDC = 0;
	// uint256 public winAmountBDT = 4e18;
	// uint256 public lossAmountBDT = 0;

	// mapping(uint256 => bool) public claimed;
	// uint256 private fightID;

	function setAuthAddress(address _authAddress) external;

	// function setHoldingAddress(address _holdingAddress) public onlyOwner
	// {
	// 	holdingAddress = _holdingAddress;
	// }

	// function setValues(uint256 _entryFee, uint256 _winAmountDC, uint256 _lossAmountDC, uint256 _winAmountBDT, uint256 _lossAmountBDT) public onlyOwner
	// {
	// 	entryFee = _entryFee;
	// 	winAmountDC = _winAmountDC;
	// 	lossAmountDC = _lossAmountDC;
	// 	winAmountBDT = _winAmountBDT;
	// 	lossAmountBDT = _lossAmountBDT;
	// }

	// function challenge(uint256 enemyID) public
	// {
	// 	dcToken.transferFrom(_msgSender(), address(this), entryFee);
	// 	dcToken.transfer(holdingAddress, entryFee);
	// 	emit Fight(fightID, _msgSender(), enemyID);
	// 	fightID++;
	// }

	// function batchClaimed(uint256[] calldata fights) public view returns (bool[] memory)
	// {
	// 	bool[] memory batch = new bool[](fights.length);
	// 	for (uint i = 0; i < fights.length; i++)
	// 		batch[i] = claimed[fights[i]];
	// 	return batch;
	// }

	// function totalRedeemable(uint256[] calldata fights, bool[] calldata victories) public view returns (uint256[2] memory)
	// {
	// 	require(fights.length == victories.length, "Array lengths must match.");
	// 	uint256 dcRewards;
	// 	uint256 bdtRewards;
	// 	for (uint i = 0; i < fights.length; i++)
	// 	{
	// 		dcRewards += victories[i] ? winAmountDC : lossAmountDC;
	// 		bdtRewards += victories[i] ? winAmountBDT : lossAmountBDT;
	// 	}
	// 	return [dcRewards, bdtRewards];
	// }

	// function redeemWinnings(uint256 fight, uint8 v, bytes32 r, bytes32 s) public
	// {
    //     bytes32 hash = keccak256(abi.encode("BDBattle_redeemWinnings", fight, _msgSender()));
    //     address signer = ecrecover(hash, v, r, s);
    //     require(signer == authAddress, "Invalid signature");
	// 	require(!claimed[fight], "Already redeemed.");
	// 	claimed[fight] = true;
	// 	dcToken.transferFrom(holdingAddress, address(this), winAmountDC);
	// 	bdtToken.transferFrom(holdingAddress, address(this), winAmountBDT);
	// 	dcToken.transfer(_msgSender(), winAmountDC);
	// 	bdtToken.transfer(_msgSender(), winAmountBDT);
	// }

	// function batchRedeemWinnings(uint256[] calldata fights, uint8 v, bytes32 r, bytes32 s) public
	// {
    //     bytes32 hash = keccak256(abi.encode("BDBattle_batchRedeemWinnings", fights, _msgSender()));
    //     address signer = ecrecover(hash, v, r, s);
    //     require(signer == authAddress, "Invalid signature");
	// 	for (uint i = 0; i < fights.length; i++)
	// 	{
	// 		require(!claimed[fights[i]], "Already redeemed.");
	// 		claimed[fights[i]] = true;
	// 	}
	// 	dcToken.transferFrom(holdingAddress, address(this), winAmountDC * fights.length);
	// 	bdtToken.transferFrom(holdingAddress, address(this), winAmountBDT * fights.length);
	// 	dcToken.transfer(_msgSender(), winAmountDC * fights.length);
	// 	bdtToken.transfer(_msgSender(), winAmountBDT * fights.length);
	// }

	// function redeemLosings(uint256 fight, uint8 v, bytes32 r, bytes32 s) public
	// {
    //     bytes32 hash = keccak256(abi.encode("BDBattle_redeemLosings", fight, _msgSender()));
    //     address signer = ecrecover(hash, v, r, s);
    //     require(signer == authAddress, "Invalid signature");
	// 	require(!claimed[fight], "Already redeemed.");
	// 	claimed[fight] = true;
	// 	dcToken.transferFrom(holdingAddress, address(this), lossAmountDC);
	// 	bdtToken.transferFrom(holdingAddress, address(this), lossAmountBDT);
	// 	dcToken.transfer(_msgSender(), lossAmountDC);
	// 	bdtToken.transfer(_msgSender(), lossAmountBDT);
	// }

	// function batchRedeemLosings(uint256[] calldata fights, uint8 v, bytes32 r, bytes32 s) public
	// {
    //     bytes32 hash = keccak256(abi.encode("BDBattle_batchRedeemLosings", fights, _msgSender()));
    //     address signer = ecrecover(hash, v, r, s);
    //     require(signer == authAddress, "Invalid signature");
	// 	for (uint i = 0; i < fights.length; i++)
	// 	{
	// 		require(!claimed[fights[i]], "Already redeemed.");
	// 		claimed[fights[i]] = true;
	// 	}
	// 	dcToken.transferFrom(holdingAddress, address(this), lossAmountDC * fights.length);
	// 	bdtToken.transferFrom(holdingAddress, address(this), lossAmountBDT * fights.length);
	// 	dcToken.transfer(_msgSender(), lossAmountDC * fights.length);
	// 	bdtToken.transfer(_msgSender(), lossAmountBDT * fights.length);
	// }

	// function batchRedeem(uint256[] calldata fights, bool[] calldata victories, uint8 v, bytes32 r, bytes32 s) public
	// {
	// 	require(fights.length == victories.length, "Array lengths must match.");
    //     bytes32 hash = keccak256(abi.encode("BDBattle_batchRedeem", fights, victories, _msgSender()));
    //     address signer = ecrecover(hash, v, r, s);
    //     require(signer == authAddress, "Invalid signature");
	// 	uint256 dcRewards;
	// 	uint256 bdtRewards;
	// 	for (uint i = 0; i < fights.length; i++)
	// 	{
	// 		if (victories[i])
	// 		{
	// 			require(!claimed[fights[i]], "Already redeemed.");
	// 			claimed[fights[i]] = true;
	// 			dcRewards += winAmountDC;
	// 			bdtRewards += winAmountBDT;
	// 		}
	// 		else 
	// 		{
	// 			require(!claimed[fights[i]], "Already redeemed.");
	// 			claimed[fights[i]] = true;
	// 			dcRewards += lossAmountDC;
	// 			bdtRewards += lossAmountBDT;
	// 		}
	// 	}
	// 	dcToken.transferFrom(holdingAddress, address(this), dcRewards);
	// 	bdtToken.transferFrom(holdingAddress, address(this), bdtRewards);
	// 	dcToken.transfer(_msgSender(), dcRewards);
	// 	bdtToken.transfer(_msgSender(), bdtRewards);
	// }
}