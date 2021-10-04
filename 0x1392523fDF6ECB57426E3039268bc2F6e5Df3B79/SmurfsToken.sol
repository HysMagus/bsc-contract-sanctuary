
/**scroll DOWN   ,8"                                     `8,
*               dP'                                        8I
*             ,8"                           bg,_          ,P'
*            ,8'                              "Y8"Ya,,,,ad"
*           ,d"                            a,_ I8   `"""'
*          ,8'                              ""888
*          dP     __                           `Yb,
*         dP'  _,d8P::::Y8b,                     `Ya
*    ,adba8',d88P::;;::;;;:"b:::Ya,_               Ya
*   dP":::"Y88P:;P"""YP"""Yb;::::::"Ya,             "Y,
*   8:::::::Yb;d" _  "_    dI:::::::::"Yb,__,,gd88ba,db
*   Yb:::::::"8(,8P _d8   d8:::::::::::::Y88P"::::::Y8I
*   `Yb;:::::::""::"":b,,dP::::::::::::::::::;aaa;:::8(
*     `Y8a;:::::::::::::::::::::;;::::::::::8P""Y8)::8I
*       8b"ba::::::::::::::::;adP:::::::::::":::dP::;8'
*       `8b;::::::::::::;aad888P::::::::::::::;dP::;8'
*        `8b;::::::::""""88"  d::::::::::b;:::::;;dP'
*          "Yb;::::::::::Y8bad::::::::::;"8Paaa""'
*            `"Y8a;;;:::::::::::::;;aadP""
*                ``""Y88bbbdddd88P""8b,
*                         _,d8"::::::"8b,
*                       ,dP8"::::::;;:::"b,
*                     ,dP"8:::::::Yb;::::"b,
*                   ,8P:dP:::::::::Yb;::::"b,
*                _,dP:;8":::::::::::Yb;::::"b
*      ,aaaaaa,,d8P:::8":::::::::::;dP:::::;8
*   ,ad":;;:::::"::::8"::::::::::;dP::::::;dI
*  dP";adP":::::;:;dP;::::aaaad88"::::::adP:8b,___
* d8:::8;;;aadP"::8'Y8:d8P"::::::::::;dP";d"'`Yb:"b
* 8I:::;""":::::;dP I8P"::::::::::;a8"a8P"     "b:P
* Yb::::"8baa8"""'  8;:;d"::::::::d8P"'         8"
*  "YbaaP::8;P      `8;d::;a::;;;;dP           ,8
*     `"Y8P"'         Yb;;d::;aadP"           ,d'
*                      "YP:::"P'             ,d'
*                        "8bdP'    _        ,8'
*                       ,8"`""Yba,d"      ,d"
*                      ,P'     d"8'     ,d"
*                     ,8'     d'8'     ,P'
*                     (b      8 I      8,
*                      Y,     Y,Y,     `b,
*                ____   "8,__ `Y,Y,     `Y""b,
*            ,adP""""b8P""""""""Ybdb,        Y,
*          ,dP"    ,dP'            `""       `8
*         ,8"     ,P'                        ,P
*         8'      8)                        ,8'
*         8,      Yb                      ,aP'
*         `Ya      Yb                  ,ad"'
*           "Ya,___ "Ya             ,ad"'
*             ``""""""`Yba,,,,,,,adP"'
*
*
* Medium: https://smurfsswap.medium.com/
* Telegram Group: https://t.me/smurfsswapfinance
* Website: https://smurfsswap.finance
* Twitter: https://twitter.com/SmurfsSwap
*/
pragma solidity 0.6.12;

import "./BEP20.sol";

// SmurfsToken with Governance.
contract SmurfsToken is BEP20('Smurfs Token', 'SMURF') {
    /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
    function mint(address _to, uint256 _amount) public onlyOwner {
        _mint(_to, _amount);
        _moveDelegates(address(0), _delegates[_to], _amount);
    }

    // Copied and modified from YAM code:
    // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
    // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
    // Which is copied and modified from COMPOUND:
    // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol

    /// @notice A record of each accounts delegate
    mapping (address => address) internal _delegates;

    /// @notice A checkpoint for marking number of votes from a given block
    struct Checkpoint {
        uint32 fromBlock;
        uint256 votes;
    }

    /// @notice A record of votes checkpoints for each account, by index
    mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;

    /// @notice The number of checkpoints for each account
    mapping (address => uint32) public numCheckpoints;

    /// @notice The EIP-712 typehash for the contract's domain
    bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");

    /// @notice The EIP-712 typehash for the delegation struct used by the contract
    bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");

    /// @notice A record of states for signing / validating signatures
    mapping (address => uint) public nonces;

      /// @notice An event thats emitted when an account changes its delegate
    event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);

    /// @notice An event thats emitted when a delegate account's vote balance changes
    event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);

    /**
     * @notice Delegate votes from `msg.sender` to `delegatee`
     * @param delegator The address to get delegatee for
     */
    function delegates(address delegator)
        external
        view
        returns (address)
    {
        return _delegates[delegator];
    }

   /**
    * @notice Delegate votes from `msg.sender` to `delegatee`
    * @param delegatee The address to delegate votes to
    */
    function delegate(address delegatee) external {
        return _delegate(msg.sender, delegatee);
    }

    /**
     * @notice Delegates votes from signatory to `delegatee`
     * @param delegatee The address to delegate votes to
     * @param nonce The contract state required to match the signature
     * @param expiry The time at which to expire the signature
     * @param v The recovery byte of the signature
     * @param r Half of the ECDSA signature pair
     * @param s Half of the ECDSA signature pair
     */
    function delegateBySig(
        address delegatee,
        uint nonce,
        uint expiry,
        uint8 v,
        bytes32 r,
        bytes32 s
    )
        external
    {
        bytes32 domainSeparator = keccak256(
            abi.encode(
                DOMAIN_TYPEHASH,
                keccak256(bytes(name())),
                getChainId(),
                address(this)
            )
        );

        bytes32 structHash = keccak256(
            abi.encode(
                DELEGATION_TYPEHASH,
                delegatee,
                nonce,
                expiry
            )
        );

        bytes32 digest = keccak256(
            abi.encodePacked(
                "\x19\x01",
                domainSeparator,
                structHash
            )
        );

        address signatory = ecrecover(digest, v, r, s);
        require(signatory != address(0), "SMURF::delegateBySig: invalid signature");
        require(nonce == nonces[signatory]++, "SMURF::delegateBySig: invalid nonce");
        require(now <= expiry, "SMURF::delegateBySig: signature expired");
        return _delegate(signatory, delegatee);
    }

    /**
     * @notice Gets the current votes balance for `account`
     * @param account The address to get votes balance
     * @return The number of current votes for `account`
     */
    function getCurrentVotes(address account)
        external
        view
        returns (uint256)
    {
        uint32 nCheckpoints = numCheckpoints[account];
        return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
    }

    /**
     * @notice Determine the prior number of votes for an account as of a block number
     * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
     * @param account The address of the account to check
     * @param blockNumber The block number to get the vote balance at
     * @return The number of votes the account had as of the given block
     */
    function getPriorVotes(address account, uint blockNumber)
        external
        view
        returns (uint256)
    {
        require(blockNumber < block.number, "SMURF::getPriorVotes: not yet determined");

        uint32 nCheckpoints = numCheckpoints[account];
        if (nCheckpoints == 0) {
            return 0;
        }

        // First check most recent balance
        if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
            return checkpoints[account][nCheckpoints - 1].votes;
        }

        // Next check implicit zero balance
        if (checkpoints[account][0].fromBlock > blockNumber) {
            return 0;
        }

        uint32 lower = 0;
        uint32 upper = nCheckpoints - 1;
        while (upper > lower) {
            uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
            Checkpoint memory cp = checkpoints[account][center];
            if (cp.fromBlock == blockNumber) {
                return cp.votes;
            } else if (cp.fromBlock < blockNumber) {
                lower = center;
            } else {
                upper = center - 1;
            }
        }
        return checkpoints[account][lower].votes;
    }

    function _delegate(address delegator, address delegatee)
        internal
    {
        address currentDelegate = _delegates[delegator];
        uint256 delegatorBalance = balanceOf(delegator); // balance of underlying CAKEs (not scaled);
        _delegates[delegator] = delegatee;

        emit DelegateChanged(delegator, currentDelegate, delegatee);

        _moveDelegates(currentDelegate, delegatee, delegatorBalance);
    }

    function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
        if (srcRep != dstRep && amount > 0) {
            if (srcRep != address(0)) {
                // decrease old representative
                uint32 srcRepNum = numCheckpoints[srcRep];
                uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
                uint256 srcRepNew = srcRepOld.sub(amount);
                _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
            }

            if (dstRep != address(0)) {
                // increase new representative
                uint32 dstRepNum = numCheckpoints[dstRep];
                uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
                uint256 dstRepNew = dstRepOld.add(amount);
                _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
            }
        }
    }

    function _writeCheckpoint(
        address delegatee,
        uint32 nCheckpoints,
        uint256 oldVotes,
        uint256 newVotes
    )
        internal
    {
        uint32 blockNumber = safe32(block.number, "CAKE::_writeCheckpoint: block number exceeds 32 bits");

        if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
            checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
        } else {
            checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
            numCheckpoints[delegatee] = nCheckpoints + 1;
        }

        emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
    }

    function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
        require(n < 2**32, errorMessage);
        return uint32(n);
    }

    function getChainId() internal pure returns (uint) {
        uint256 chainId;
        assembly { chainId := chainid() }
        return chainId;
    }
}