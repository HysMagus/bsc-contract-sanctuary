interface IXvsCheck {
    function getXVSBalanceMetadataExt(address xvs, address contr, address user) external returns (uint256, uint256, uint256, uint256);
}


// abi to call 
/*
interface IVenusXvsCheck {
    function getPendingXvs(address account) external view returns (uint256) ;
}
*/

contract VenusXvsCheck {
    IXvsCheck xvsCheck = IXvsCheck(0x595e9DDfEbd47B54b996c839Ef3Dd97db3ED19bA);
    address xvs = 0xcF6BB5389c92Bdda8a3747Ddb454cB7a64626C63;
    address comptroller = 0xfD36E2c2a6789Db23113685031d7F16329158384; 
    
    function getPendingXvs(address account) external returns (uint256) {
        ( , , , uint256 pendingXvs) = xvsCheck.getXVSBalanceMetadataExt(xvs, comptroller, account);
        return pendingXvs;
    }
}