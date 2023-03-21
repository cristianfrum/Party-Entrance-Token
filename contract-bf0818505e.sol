// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts@4.8.2/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.8.2/access/AccessControl.sol";

contract PartyEntranceToken is ERC20, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    event TokenEntryPurchased(address indexed receiver, address indexed buyer);
    
    ERC20 public token;

    constructor() ERC20("PartyEntranceToken", "PETK") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    }

    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount * 10 ** decimals());
    }

    function buyOneToken() public {
        _burn(_msgSender(), 1 * 10 ** decimals());
        emit TokenEntryPurchased(_msgSender(), _msgSender());
    }

    function buyOneTokenFrom(address account) public {
        _spendAllowance(account, _msgSender(), 1 * 10 ** token.decimals());
        _burn(account, 1 * 10 ** token.decimals());
        emit TokenEntryPurchased(_msgSender(), account);
    }
}
