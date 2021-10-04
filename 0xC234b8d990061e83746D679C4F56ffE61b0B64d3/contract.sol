pragma solidity 0.4.25;

interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

library MerkleProof {
    function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
        bytes32 computedHash = leaf;
        for (uint256 i = 0; i < proof.length; i++) {
            bytes32 proofElement = proof[i];

            if (computedHash <= proofElement) {
                computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
            } else {
                computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
            }
        }
        return computedHash == root;
    }
}

contract BSCAirdrop {
    address public bscToken = 0x17bc015607Fdf93e7C949e9Ca22f96907cFBeF88;
    address owner;
    bytes32 public rootHash;
    mapping(address => bool) claimChecker;
    
    uint airDropAmount = 10 ** 17;
    
    event Claimed(address _holder, uint256 amount);
    
    constructor(bytes32 _rootHash) public {
        rootHash = _rootHash;
        owner = msg.sender;
    }
    
    function claim(address _address, bytes32[] _path) external {
        require(!claimChecker[_address], 'BSCAirdrop: Claim already!!!');
        bytes32 hash = keccak256(abi.encodePacked(_address));
        require(MerkleProof.verify(_path, rootHash, hash), 'BSCAirdrop: 400');
        claimChecker[_address] = true;
        require(IERC20(bscToken).transfer(_address, airDropAmount), 'BSCAirdrop: Transfer failed.');
        
        emit Claimed(_address, airDropAmount);
    }
    
    function drain() external {
        require(msg.sender == owner, 'BSCAirdrop: 401');
        require(IERC20(bscToken).transfer(owner, IERC20(bscToken).balanceOf(address(this))), 'BSCAirdrop: Transfer failed.');
    }
}