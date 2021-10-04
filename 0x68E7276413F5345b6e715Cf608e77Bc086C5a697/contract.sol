//SPDX-License-Identifier:MIT

pragma solidity 0.8.6;


/// @title Freeleancer-Client Agreement for Web Development of Token Dashboard
/// @author azn_kid (telegram username)
/** @notice Agreement
 * 
 * Definitions:
 * tg - Telegram chat app
 * Developer - freelancer hired to build the dashboard azn_kid (tg username)
 * Client - the customer, "X Token" CryptoMoonLife (tg username) DeltaRising (tg username)
 * Token - the token project created by Client
 * User/s - a token holder using the dashboard
 * 
 * Requirement:
 * A dashboard webpage that displays the following information about the Token and its Users:
 * 
 * balance of user
 * total rewards received by User
 * total rewards dispensed by Token
 * latest payout amount received by User
 * latest payout amount dispensed by Token
 * list of last 10 payouts to User with verification links to bscscan.com
 * list of last 10 payouts dispensed by Token with verification links to bscscan.com
 * simple wallet address entry field, no wallet connect interface
 * no manual claim feature
 * 
 * Hosting:
 * Client will host all the frontend files (html, javascript, css).
 * Some read-only data including as price, market cap, no. of holders, and latest payouts, 
 * are hosted by and requested from third-party websites such as bscscan.com, bscrewards.app, and coingecko.com.
 * Client will upload the frontend files themselves, the Developer will not be given access to Client's web server.
 * 
 * Domain:
 * Domain is not covered by the fee. The Client will provide the domain or subdomain.
 * 
 * Testing:
 * A test URL will be provided to the Client, and will be taken down immediately upon delivery of the frontend files.
 * The Developer will assist the Client in deploying and testing the frontend files.
 * The Developer will conduct ample testing together with the client to ensure that the final product works
 * according to the requirements above.
 * The Developer will test the webpage on most popular browsers on desktop and mobile (Chrome, Firefox, Edge, Safari)
 * 
 * Disclaimer:
 * While sufficient testing will be conducted, the Developer but does not guarantee that the final product will
 * work in other browsers or future versions of the browsers mentioned above. The final product will be given
 * as-is, and any revision after deployment may require additional fees from the Client.
 * 
 * The Developer is not affiliated with the Client outside of the scope of this freelance project, and must not 
 * be held liable for any actions of the Client.
 * The Developer must not be held liable for any service interruptions on the Cient's website,
 * or interruptions on the third-party websites mentioned here. 
 * Bscscan.com, coingecko.com, and bscrewards.app are third-party services NOT AFFILIATED with the Client
 * and must not be held responsible for the outcome of the Token,especially when there are service interruptions,
 * which must be expected of all web-based services.
 * They must not be held liable for any actions of the Client.
 * 
 * Fees:
 * For the requirements above, the Developer and Client have agreed on 2.5 BNB to be paid to Developer
 * 1.25 BNB to be paid upon signing this smart contract
 * 1.25 BNB to be paid immediately after the token's launch.
 * 
 * Delivery Date: The Developer must deliver the final product not later than Sunday, October 3, 2021
 * 
 * Signature:
 * Sending any amount to this contract will be considered as a signature and acceptance of the above terms.
 * Any sender address other than the developer_wallet defined in this smart contract is presumed to be
 * the Client's address or addresses.
 * Alternatively, the Client may simply execute the write function sign_agreement() with the wallet they 
 * intend to pay with if they wish to send funds directly to the developer_wallet.
*/

contract freelance_agreement{

    mapping(address => bool) signature;
    
    address public developer_wallet=0x04e3493D8ABA5B19A1D685B002bd3a3694391736;

    constructor() {}
    
    /* This contract also acts as an alias for the developer_wallet.
    Any funds sent to this address will be transferred to the developer_wallet.
    Sending any amount to this smart contract is considered a digital signature
    and an acceptance of the agreement above */
    
    receive() external payable {
        signature[msg.sender]=true;
        address payable _dev_wallet=payable(developer_wallet);
        _dev_wallet.transfer(msg.value);
    }
    
    /* Alternatively, parties (represented by their address) can sign the
    agreement in this smart contract by executing this write function via bscscan.com */
    
    /// @notice By executing this function, you agree to the terms of this smart ontract.
    function sign_agreement() public {
        signature[msg.sender]=true;
    }
    
    /* Use the following read function to verify that a certain party (represented by their address)
    has signed the agreement in this smart contract. Returns TRUE if signed, otherwise FALSE. */
    
    function check_signature(address _address) public view returns (bool) {
        return signature[_address];
    }
}