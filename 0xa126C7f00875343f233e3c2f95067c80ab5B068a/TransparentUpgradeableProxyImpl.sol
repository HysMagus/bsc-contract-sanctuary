// SPDX-License-Identifier: GPL-2.0
pragma solidity =0.7.6;
/*

    :::     :::::::::  :::::::::: :::::::::   ::::::::   ::::::::  :::    ::: :::::::::: ::::::::::: 
  :+: :+:   :+:    :+: :+:        :+:    :+: :+:    :+: :+:    :+: :+:   :+:  :+:            :+:     
 +:+   +:+  +:+    +:+ +:+        +:+    +:+ +:+    +:+ +:+        +:+  +:+   +:+            +:+     
+#++:++#++: +#++:++#+  +#++:++#   +#++:++#:  +#+    +:+ +#+        +#++:++    +#++:++#       +#+     
+#+     +#+ +#+        +#+        +#+    +#+ +#+    +#+ +#+        +#+  +#+   +#+            +#+     
#+#     #+# #+#        #+#        #+#    #+# #+#    #+# #+#    #+# #+#   #+#  #+#            #+#     
###     ### ###        ########## ###    ###  ########   ########  ###    ### ##########     ### 

* App       :   https://aperocket.finance
* Discord   :   https://aperocket.finance
* Medium    :   https://aperocket.medium.com/
* Twitter   :   https://twitter.com/aperocketfi
* Telegram  :   https://t.me/aperocket
* GitHub    :   https://github.com/aperocket-labs

 */
import "@openzeppelin/contracts/proxy/TransparentUpgradeableProxy.sol";

contract TransparentUpgradeableProxyImpl is TransparentUpgradeableProxy {
    constructor(
        address _logic,
        address _admin,
        bytes memory _data
    ) payable TransparentUpgradeableProxy(_logic, _admin, _data) {}
}
