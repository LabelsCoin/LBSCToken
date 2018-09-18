pragma solidity ^0.4.24;

import "./BaseLBSCToken.sol";

contract LBSCToken is BaseLBSCToken {
    
    // Constants
    string  public constant name = "LabelsCoin";
    string  public constant symbol = "LBSC";
    uint8   public constant decimals = 18;

    uint256 public constant INITIAL_SUPPLY      =  30000000 * (10 ** uint256(decimals));
    //uint256 public constant CROWDSALE_ALLOWANCE =  1000000000 * (10 ** uint256(decimals));
    uint256 public constant ADMIN_ALLOWANCE     =  30000000 * (10 ** uint256(decimals));
    
    // Properties
    //uint256 public totalSupply;
    //uint256 public crowdSaleAllowance;      // the number of tokens available for crowdsales
    uint256 public adminAllowance;          // the number of tokens available for the administrator
    //address public crowdSaleAddr;           // the address of a crowdsale currently selling this token
    address public adminAddr;               // the address of a crowdsale currently selling this token
    //bool    public transferEnabled = false; // indicates if transferring tokens is enabled or not
    bool    public transferEnabled = true;  // Enables everyone to transfer tokens

    /**
     * The listed addresses are not valid recipients of tokens.
     *
     * 0x0           - the zero address is not valid
     * this          - the contract itself should not receive tokens
     * owner         - the owner has all the initial tokens, but cannot receive any back
     * adminAddr     - the admin has an allowance of tokens to transfer, but does not receive any
     * crowdSaleAddr - the crowdsale has an allowance of tokens to transfer, but does not receive any
     */
    modifier validDestination(address _to) {
        require(_to != address(0x0), "Cannot send to 0 address");
        require(_to != address(this), "Cannot send to contract address");
        //require(_to != owner, "Cannot send to the owner");
        //require(_to != address(adminAddr), "Cannot send to admin address");
        //require(_to != address(crowdSaleAddr), "Cannot send to crowdsale address");
        _;
    }

    constructor(address _admin) public {
        require(msg.sender != _admin, "Owner and admin cannot be the same");

        totalSupply_ = INITIAL_SUPPLY;
        adminAllowance = ADMIN_ALLOWANCE;

        // mint all tokens
        //balances[msg.sender] = totalSupply_.sub(adminAllowance);
        //emit Transfer(address(0x0), msg.sender, totalSupply_.sub(adminAllowance));

        balances[_admin] = adminAllowance;
        emit Transfer(address(0x0), _admin, adminAllowance);

        adminAddr = _admin;
        approve(adminAddr, adminAllowance);
    }

    /**
     * Overrides ERC20 transfer function with modifier that prevents the
     * ability to transfer tokens until after transfers have been enabled.
     */
    function transfer(address _to, uint256 _value) public validDestination(_to) returns (bool) {
        return super.transfer(_to, _value);
    }

    /**
     * Overrides ERC20 transferFrom function with modifier that prevents the
     * ability to transfer tokens until after transfers have been enabled.
     */
    function transferFrom(address _from, address _to, uint256 _value) public validDestination(_to) returns (bool) {
        bool result = super.transferFrom(_from, _to, _value);
        if (result) {
            if (msg.sender == adminAddr)
                adminAllowance = adminAllowance.sub(_value);
        }
        return result;
    }
}