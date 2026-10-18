// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import "openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";
import "openzeppelin-contracts-upgradeable/contracts/token/ERC20/ERC20Upgradeable.sol";
import "openzeppelin-contracts-upgradeable/contracts/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";

contract TheWeb3Token2 is
Initializable,
OwnableUpgradeable,
ERC20Upgradeable,
ERC20BurnableUpgradeable
{
    struct theWeb3CoinPool {
        address miningPool;
        address directSalePool;
        address investorSalePool;
        address ecosystemPool;
        address foundationPool;
    }

    event SetManager(address indexed newAddress, address oldAddress);
    event SetPoolAddress(theWeb3CoinPool indexed pool);

    uint256 public constant MaxTotalSupply = 1_000_000_000 * 10 ** 6;

    string internal constant NAME = "TheWebThree Coin";
    string internal constant SYMBOL = "TWT";

    theWeb3CoinPool public twPool;

    bool public isAllocation;

    address public manager;

    constructor() {
        _disableInitializers();
    }

    modifier onlyManager() {
        require(
            msg.sender == manager,
            "TheWebThreeToken onlyManager: Only manager can call this function"
        );
        _;
    }

    function setManager(address _manager) external onlyOwner {
        address oldAddress = manager;
        manager = _manager;
        emit SetManager(_manager,oldAddress);
    }

    function setPoolAddress(theWeb3CoinPool memory _twPool) external onlyOwner {
        _beforeAllocation();
        _beforePoolAddress(_twPool);
        twPool = _twPool;
        emit SetPoolAddress(_twPool);
    }

    function initialize(address _owner, address _manager) public initializer {
        require(
            _owner != address(0),
            "TheWebThreeToken initialize: _owner can't be zero address"
        );
        __ERC20_init(NAME, SYMBOL);
        __ERC20Burnable_init();
        __Ownable_init(_owner);
        _transferOwnership(_owner);
        manager = _manager;
        isAllocation = false;
    }

    function decimals() public view virtual override returns (uint8) {
        return 6;
    }

    function tokenBalance(address _address) external view virtual returns (uint256) {
        return balanceOf(_address);
    }

    // 发币
    function poolAllocate() external onlyManager {
        _beforeAllocation();
        _mint(twPool.miningPool, (MaxTotalSupply * 3) / 10); // 30% of total supply
        _mint(twPool.directSalePool, (MaxTotalSupply * 2) / 10); // 20% of total supply
        _mint(twPool.investorSalePool, MaxTotalSupply / 10); // 10% of total supply
        _mint(twPool.ecosystemPool, MaxTotalSupply / 10); // 10% of total supply
        _mint(twPool.foundationPool, (MaxTotalSupply * 3) / 10); // 30% of total supply
        isAllocation = true;
    }


    // ====== internal =======
    function _beforeAllocation() internal virtual {
        require(
            !isAllocation,
            "TheWebThreeToken _beforeAllocation:TWT is already allocate"
        );
    }

    function _beforePoolAddress(theWeb3CoinPool memory _pool) internal virtual {
        require(
            _pool.miningPool != address(0),
            "TheWebThreeToken _beforeAllocation:Missing allocate MiningPool address"
        );
        require(
            _pool.directSalePool != address(0),
            "TheWebThreeToken _beforeAllocation:Missing allocate DirectSalePool address"
        );
        require(
            _pool.investorSalePool != address(0),
            "TheWebThreeToken _beforeAllocation:Missing allocate InvestorSalePool address"
        );
        require(
            _pool.ecosystemPool != address(0),
            "TheWebThreeToken _beforeAllocation:Missing allocate EcosystemPool address"
        );
        require(
            _pool.foundationPool != address(0),
            "TheWebThreeToken _beforeAllocation:Missing allocate FoundationPool address"
        );
    }
}
