# Sstan - v0.1.0 

 --- 
 TODO: add description

# Summary




## Vulnerabilities 

 | Classification | Title | Instances | 
 |:-------:|:---------|:-------:| 
 | [[Low-0]](#[Low-0]) | Use a locked pragma version instead of a floating pragma version | 13 |
 | [[Low-1]](#[Low-1]) | Unsafe ERC20 Operation | 2 |
## Optimizations 

 | Classification | Title | Instances | 
 |:-------:|:---------|:-------:| 
 | [[Gas-0]](#[Gas-0]) | Pack Structs | 2 |
 | [[Gas-1]](#[Gas-1]) | Mark storage variables as `constant` if they never change. | 1 |
 | [[Gas-2]](#[Gas-2]) | Mark storage variables as `immutable` if they never change after contract initialization. | 1 |
 | [[Gas-3]](#[Gas-3]) | Use custom errors instead of string error messages | 1 |
 | [[Gas-4]](#[Gas-4]) | Use assembly for math (add, sub, mul, div) | 1 |
 | [[Gas-5]](#[Gas-5]) | Event is not properly indexed. | 9 |
 | [[Gas-6]](#[Gas-6]) | Mark functions as payable (with discretion) | 1 |
 | [[Gas-7]](#[Gas-7]) | Use assembly when getting a contract's balance of ETH | 1 |
## Quality Assurance 

 | Classification | Title | Instances | 
 |:-------:|:---------|:-------:| 
 | [[NonCritical-0]](#[NonCritical-0]) | Constructor should check that all parameters are not 0 | 3 |
 | [[NonCritical-1]](#[NonCritical-1]) | This error has no parameters, the state of the contract when the revert occured will not be available | 31 |
 | [[NonCritical-2]](#[NonCritical-2]) | Function names should be in camelCase | 35 |
 | [[NonCritical-3]](#[NonCritical-3]) | Consider importing specific identifiers instead of the whole file | 4 |
 | [[NonCritical-4]](#[NonCritical-4]) | Function parameters should be in camelCase | 192 |

## Vulnerabilities - Total: 15 

<a name=[Low-0]></a>
### [Low-0] Use a locked pragma version instead of a floating pragma version - Instances: 13 

 > ""
        Floating pragma is a vulnerability in smart contract code that can cause unexpected behavior by allowing the compiler to use a specified range of versions. \n This can lead to issues such as using an older compiler version with known vulnerabilities, using a newer compiler version with undiscovered vulnerabilities, inconsistency across files using different versions, or unpredictable behavior because the compiler can use any version within the specified range. It is recommended to use a locked pragma version in order to avoid these potential vulnerabilities. In some cases it may be acceptable to use a floating pragma, such as when a contract is intended for consumption by other developers and needs to be compatible with a range of compiler versions.
        <details>
        <summary>Expand Example</summary>

        #### Bad

        ```js
            pragma solidity ^0.8.0;
        ```

        #### Good

        ```js
            pragma solidity 0.8.15;
        ```
        </details>
        "" 

 --- 

File:ILBToken.sol#L3
```solidity
2:pragma solidity ^0.8.10;
``` 



File:ILBRouter.sol#L3
```solidity
2:pragma solidity ^0.8.10;
``` 



File:IERC165.sol#L4
```solidity
3:pragma solidity ^0.8.0;
``` 



File:IPendingOwnable.sol#L3
```solidity
2:pragma solidity ^0.8.10;
``` 



File:ILBLegacyPair.sol#L3
```solidity
2:pragma solidity ^0.8.10;
``` 



File:ILBLegacyFactory.sol#L3
```solidity
2:pragma solidity ^0.8.10;
``` 



File:ILBPair.sol#L3
```solidity
2:pragma solidity ^0.8.10;
``` 



File:ILBFactory.sol#L3
```solidity
2:pragma solidity ^0.8.10;
``` 



File:ILBLegacyRouter.sol#L3
```solidity
2:pragma solidity ^0.8.10;
``` 



File:ILBLegacyToken.sol#L3
```solidity
2:pragma solidity ^0.8.10;
``` 



File:IJoeFactory.sol#L3
```solidity
2:pragma solidity ^0.8.10;
``` 



File:ILBFlashLoanCallback.sol#L3
```solidity
2:pragma solidity ^0.8.10;
``` 



File:IWNATIVE.sol#L3
```solidity
2:pragma solidity ^0.8.10;
``` 



 --- 

<a name=[Low-1]></a>
### [Low-1] Unsafe ERC20 Operation - Instances: 2 

 > ""
        ERC20 operations can be unsafe due to different implementations and vulnerabilities in the standard. To account for this, either use OpenZeppelin's SafeERC20 library or wrap each operation in a require statement. \n
        > Additionally, ERC20's approve functions have a known race-condition vulnerability. To account for this, use OpenZeppelin's SafeERC20 library's `safeIncrease` or `safeDecrease` Allowance functions.
        <details>
        <summary>Expand Example</summary>

        #### Unsafe Transfer

        ```js
        IERC20(token).transfer(msg.sender, amount);
        ```

        #### OpenZeppelin SafeTransfer

        ```js
        import {SafeERC20} from \"openzeppelin/token/utils/SafeERC20.sol\";
        //--snip--

        IERC20(token).safeTransfer(msg.sender, address(this), amount);
        ```
                
        #### Safe Transfer with require statement.

        ```js
        bool success = IERC20(token).transfer(msg.sender, amount);
        require(success, \"ERC20 transfer failed\");
        ```
                
        #### Unsafe TransferFrom

        ```js
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        ```

        #### OpenZeppelin SafeTransferFrom

        ```js
        import {SafeERC20} from \"openzeppelin/token/utils/SafeERC20.sol\";
        //--snip--

        IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
        ```
                
        #### Safe TransferFrom with require statement.

        ```js
        bool success = IERC20(token).transferFrom(msg.sender, address(this), amount);
        require(success, \"ERC20 transfer failed\");
        ```

        </details>
        "" 

 --- 

File:BotRouter.sol#L51
```solidity
50:        payable(msg.sender).transfer(valueAfterFees);
``` 



File:BotRouter.sol#L58
```solidity
57:        payable(owner()).transfer(contractBalance);
``` 



 --- 



## Optimizations - Total: 17 

<a name=[Gas-0]></a>
### [Gas-0] Pack Structs - Instances: 2 

 > 
 When creating structs, make sure that the variables are listed in ascending order by data type. The compiler will pack the variables that can fit into one 32 byte slot. If the variables are not listed in ascending order, the compiler may not pack the data into one slot, causing additional `sload` and `sstore` instructions when reading/storing the struct into the contract's storage. - Savings: ~0 
 

 --- 

File:ILBLegacyFactory.sol#L19
```solidity
18:    struct LBPairInformation {
19:        uint16 binStep;
20:        ILBLegacyPair LBPair;
21:        bool createdByOwner;
22:        bool ignoredForRouting;
23:    }
24:
``` 



File:ILBFactory.sol#L42
```solidity
41:    struct LBPairInformation {
42:        uint16 binStep;
43:        ILBPair LBPair;
44:        bool createdByOwner;
45:        bool ignoredForRouting;
46:    }
47:
``` 



 --- 

<a name=[Gas-1]></a>
### [Gas-1] Mark storage variables as `constant` if they never change. - Instances: 1 

 > 
 State variables can be declared as constant or immutable. In both cases, the variables cannot be modified after the contract has been constructed. For constant variables, the value has to be fixed at compile-time, while for immutable, it can still be assigned at construction time. 
 The compiler does not reserve a storage slot for these variables, and every occurrence is inlined by the respective value. 
 Compared to regular state variables, the gas costs of constant and immutable variables are much lower. For a constant variable, the expression assigned to it is copied to all the places where it is accessed and also re-evaluated each time. This allows for local optimizations. Immutable variables are evaluated once at construction time and their value is copied to all the places in the code where they are accessed. For these values, 32 bytes are reserved, even if they would fit in fewer bytes. Due to this, constant values can sometimes be cheaper than immutable values. - Savings: ~2103 
 

 --- 

File:BotRouter.sol#L12
```solidity
11:    address public nativeAvax = address(native);
``` 



File:BotRouter.sol#L14
```solidity
13:    uint128 public sellFee = 200; // 2% in basis points (parts per 10,000)
``` 



 --- 

<a name=[Gas-2]></a>
### [Gas-2] Mark storage variables as `immutable` if they never change after contract initialization. - Instances: 1 

 > 
 State variables can be declared as constant or immutable. In both cases, the variables cannot be modified after the contract has been constructed. For constant variables, the value has to be fixed at compile-time, while for immutable, it can still be assigned at construction time. 
 The compiler does not reserve a storage slot for these variables, and every occurrence is inlined by the respective value. 
 Compared to regular state variables, the gas costs of constant and immutable variables are much lower. For a constant variable, the expression assigned to it is copied to all the places where it is accessed and also re-evaluated each time. This allows for local optimizations. Immutable variables are evaluated once at construction time and their value is copied to all the places in the code where they are accessed. For these values, 32 bytes are reserved, even if they would fit in fewer bytes. Due to this, constant values can sometimes be cheaper than immutable values. 
 - Savings: ~2103 
 

 --- 

File:BotRouter.sol#L10
```solidity
9:    IWNATIVE public native;
``` 



File:BotRouter.sol#L9
```solidity
8:    ILBRouter public router;
``` 



 --- 

<a name=[Gas-3]></a>
### [Gas-3] Use custom errors instead of string error messages - Instances: 1 

 > 
 Using custom errors will save you gas, and can be used to provide more information about the error. - Savings: ~57 
 

 --- 

File:BotRouter.sol#L57
```solidity
56:        require(contractBalance > 0, "No funds available for withdrawal.");
``` 



 --- 

<a name=[Gas-4]></a>
### [Gas-4] Use assembly for math (add, sub, mul, div) - Instances: 1 

 > 
 Use assembly for math instead of Solidity. You can check for overflow/underflow in assembly to ensure safety. If using Solidity versions < 0.8.0 and you are using Safemath, you can gain significant gas savings by using assembly to calculate values and checking for overflow/underflow. - Savings: ~60 
 

 --- 

File:BotRouter.sol#L47
```solidity
46:        uint256 value = balanceAfter - balanceBefore;
``` 



File:BotRouter.sol#L49
```solidity
48:        uint256 valueAfterFees = (value * sellFee) / 10_000;
``` 



File:BotRouter.sol#L49
```solidity
48:        uint256 valueAfterFees = (value * sellFee) / 10_000;
``` 



 --- 

<a name=[Gas-5]></a>
### [Gas-5] Event is not properly indexed. - Instances: 9 

 > 
 When possible, always include a minimum of 3 indexed event topics to save gas - Savings: ~0 
 

 --- 

File:ILBToken.sol#L22
```solidity
21:    event ApprovalForAll(address indexed account, address indexed sender, bool approved);
``` 



File:ILBFactory.sol#L53
```solidity
52:    event FeeRecipientSet(address oldRecipient, address newRecipient);
``` 



File:ILBFactory.sol#L55
```solidity
54:    event FlashLoanFeeSet(uint256 oldFlashLoanFee, uint256 newFlashLoanFee);
``` 



File:ILBFactory.sol#L57
```solidity
56:    event LBPairImplementationSet(address oldLBPairImplementation, address LBPairImplementation);
``` 



File:ILBFactory.sol#L59
```solidity
58:    event LBPairIgnoredStateChanged(ILBPair indexed LBPair, bool ignored);
``` 



File:ILBFactory.sol#L61
```solidity
60:    event PresetSet(
61:        uint256 indexed binStep,
62:        uint256 baseFactor,
63:        uint256 filterPeriod,
64:        uint256 decayPeriod,
65:        uint256 reductionFactor,
66:        uint256 variableFeeControl,
67:        uint256 protocolShare,
68:        uint256 maxVolatilityAccumulator
69:    );
``` 



File:ILBLegacyFactory.sol#L30
```solidity
29:    event FeeRecipientSet(address oldRecipient, address newRecipient);
``` 



File:ILBLegacyFactory.sol#L32
```solidity
31:    event FlashLoanFeeSet(uint256 oldFlashLoanFee, uint256 newFlashLoanFee);
``` 



File:ILBLegacyFactory.sol#L34
```solidity
33:    event FeeParametersSet(
34:        address indexed sender,
35:        ILBLegacyPair indexed LBPair,
36:        uint256 binStep,
37:        uint256 baseFactor,
38:        uint256 filterPeriod,
39:        uint256 decayPeriod,
40:        uint256 reductionFactor,
41:        uint256 variableFeeControl,
42:        uint256 protocolShare,
43:        uint256 maxVolatilityAccumulator
44:    );
``` 



File:ILBLegacyFactory.sol#L47
```solidity
46:    event FactoryLockedStatusUpdated(bool unlocked);
``` 



File:ILBLegacyFactory.sol#L49
```solidity
48:    event LBPairImplementationSet(address oldLBPairImplementation, address LBPairImplementation);
``` 



File:ILBLegacyFactory.sol#L51
```solidity
50:    event LBPairIgnoredStateChanged(ILBLegacyPair indexed LBPair, bool ignored);
``` 



File:ILBLegacyFactory.sol#L53
```solidity
52:    event PresetSet(
53:        uint256 indexed binStep,
54:        uint256 baseFactor,
55:        uint256 filterPeriod,
56:        uint256 decayPeriod,
57:        uint256 reductionFactor,
58:        uint256 variableFeeControl,
59:        uint256 protocolShare,
60:        uint256 maxVolatilityAccumulator,
61:        uint256 sampleLifetime
62:    );
``` 



File:IJoeFactory.sol#L8
```solidity
7:    event PairCreated(address indexed token0, address indexed token1, address pair, uint256);
``` 



File:IERC20.sol#L4
```solidity
3:    event Approval(address indexed owner, address indexed spender, uint value);
``` 



File:IERC20.sol#L5
```solidity
4:    event Transfer(address indexed from, address indexed to, uint value);
``` 



File:ILBLegacyPair.sol#L146
```solidity
145:    event FlashLoan(address indexed sender, address indexed receiver, IERC20 token, uint256 amount, uint256 fee);
``` 



File:ILBLegacyPair.sol#L160
```solidity
159:    event FeesCollected(address indexed sender, address indexed recipient, uint256 amountX, uint256 amountY);
``` 



File:ILBLegacyPair.sol#L162
```solidity
161:    event ProtocolFeesCollected(address indexed sender, address indexed recipient, uint256 amountX, uint256 amountY);
``` 



File:ILBLegacyPair.sol#L164
```solidity
163:    event OracleSizeIncreased(uint256 previousSize, uint256 newSize);
``` 



File:BotRouter.sol#L16
```solidity
15:    event FundsWithdrawn(uint256 amount);
``` 



File:ILBPair.sol#L41
```solidity
40:    event CompositionFees(address indexed sender, uint24 id, bytes32 totalFees, bytes32 protocolFees);
``` 



File:ILBPair.sol#L43
```solidity
42:    event CollectedProtocolFees(address indexed feeRecipient, bytes32 protocolFees);
``` 



File:ILBPair.sol#L45
```solidity
44:    event Swap(
45:        address indexed sender,
46:        address indexed to,
47:        uint24 id,
48:        bytes32 amountsIn,
49:        bytes32 amountsOut,
50:        uint24 volatilityAccumulator,
51:        bytes32 totalFees,
52:        bytes32 protocolFees
53:    );
``` 



File:ILBPair.sol#L56
```solidity
55:    event StaticFeeParametersSet(
56:        address indexed sender,
57:        uint16 baseFactor,
58:        uint16 filterPeriod,
59:        uint16 decayPeriod,
60:        uint16 reductionFactor,
61:        uint24 variableFeeControl,
62:        uint16 protocolShare,
63:        uint24 maxVolatilityAccumulator
64:    );
``` 



File:ILBPair.sol#L67
```solidity
66:    event FlashLoan(
67:        address indexed sender,
68:        ILBFlashLoanCallback indexed receiver,
69:        uint24 activeId,
70:        bytes32 amounts,
71:        bytes32 totalFees,
72:        bytes32 protocolFees
73:    );
``` 



File:ILBPair.sol#L76
```solidity
75:    event OracleLengthIncreased(address indexed sender, uint16 oracleLength);
``` 



File:ILBPair.sol#L78
```solidity
77:    event ForcedDecay(address indexed sender, uint24 idReference, uint24 volatilityReference);
``` 



File:ILBLegacyToken.sol#L17
```solidity
16:    event ApprovalForAll(address indexed account, address indexed sender, bool approved);
``` 



 --- 

<a name=[Gas-6]></a>
### [Gas-6] Mark functions as payable (with discretion) - Instances: 1 

 > 
 You can mark public or external functions as payable to save gas. Functions that are not payable have additional logic to check if there was a value sent with a call, however, making a function payable eliminates this check. This optimization should be carefully considered due to potentially unwanted behavior when a function does not need to accept ether. - Savings: ~24 
 

 --- 

File:BotRouter.sol#L35
```solidity
34:    function sell(address _tokenIn, uint256 amountOutMin, uint256 amountInMax, uint256 deadline) external {
``` 



File:BotRouter.sol#L54
```solidity
53:    function withdrawFees() external onlyOwner {
``` 



 --- 

<a name=[Gas-7]></a>
### [Gas-7] Use assembly when getting a contract's balance of ETH - Instances: 1 

 > 
 You can use `selfbalance()` instead of `address(this).balance` when getting your contract's balance of ETH to save gas. Additionally, you can use `balance(address)` instead of `address.balance()` when getting an external contract's balance of ETH. - Savings: ~15 
 

 --- 

File:BotRouter.sol#L42
```solidity
41:        uint256 balanceBefore = address(this).balance;
``` 



File:BotRouter.sol#L45
```solidity
44:        uint256 balanceAfter = address(this).balance;
``` 



File:BotRouter.sol#L56
```solidity
55:        uint256 contractBalance = address(this).balance;
``` 



 --- 



## Quality Assurance - Total: 265 

<a name=[NonCritical-0]></a>
### [NonCritical-0] Constructor should check that all parameters are not 0 - Instances: 3 

 > Consider adding a require statement to check that all parameters are not 0 in the constructor 

 --- 

File:BotRouter.sol#L19
```solidity
18:    constructor(address _router, address _native, address initialOwner) Ownable(initialOwner) payable {
``` 



File:BotRouter.sol#L19
```solidity
18:    constructor(address _router, address _native, address initialOwner) Ownable(initialOwner) payable {
``` 



File:BotRouter.sol#L19
```solidity
18:    constructor(address _router, address _native, address initialOwner) Ownable(initialOwner) payable {
``` 



 --- 

<a name=[NonCritical-1]></a>
### [NonCritical-1] This error has no parameters, the state of the contract when the revert occured will not be available - Instances: 31 

 > Consider adding parameters to the error to provide more context when a transaction fails 

 --- 

File:ILBPair.sol#L12
```solidity
11:    error LBPair__ZeroBorrowAmount();
``` 



File:ILBPair.sol#L13
```solidity
12:    error LBPair__AddressZero();
``` 



File:ILBPair.sol#L14
```solidity
13:    error LBPair__AlreadyInitialized();
``` 



File:ILBPair.sol#L15
```solidity
14:    error LBPair__EmptyMarketConfigs();
``` 



File:ILBPair.sol#L16
```solidity
15:    error LBPair__FlashLoanCallbackFailed();
``` 



File:ILBPair.sol#L17
```solidity
16:    error LBPair__FlashLoanInsufficientAmount();
``` 



File:ILBPair.sol#L18
```solidity
17:    error LBPair__InsufficientAmountIn();
``` 



File:ILBPair.sol#L19
```solidity
18:    error LBPair__InsufficientAmountOut();
``` 



File:ILBPair.sol#L20
```solidity
19:    error LBPair__InvalidInput();
``` 



File:ILBPair.sol#L21
```solidity
20:    error LBPair__InvalidStaticFeeParameters();
``` 



File:ILBPair.sol#L22
```solidity
21:    error LBPair__OnlyFactory();
``` 



File:ILBPair.sol#L23
```solidity
22:    error LBPair__OnlyProtocolFeeRecipient();
``` 



File:ILBPair.sol#L24
```solidity
23:    error LBPair__OutOfLiquidity();
``` 



File:ILBPair.sol#L25
```solidity
24:    error LBPair__TokenNotSupported();
``` 



File:ILBPair.sol#L29
```solidity
28:    error LBPair__MaxTotalFeeExceeded();
``` 



File:ILBRouter.sol#L21
```solidity
20:    error LBRouter__SenderIsNotWNATIVE();
``` 



File:ILBRouter.sol#L25
```solidity
24:    error LBRouter__BrokenSwapSafetyCheck();
``` 



File:ILBRouter.sol#L26
```solidity
25:    error LBRouter__NotFactoryOwner();
``` 



File:ILBRouter.sol#L30
```solidity
29:    error LBRouter__LengthsMismatch();
``` 



File:ILBRouter.sol#L31
```solidity
30:    error LBRouter__WrongTokenOrder();
``` 



File:ILBFactory.sol#L19
```solidity
18:    error LBFactory__AddressZero();
``` 



File:ILBFactory.sol#L26
```solidity
25:    error LBFactory__LBPairIgnoredIsAlreadyInTheSameState();
``` 



File:ILBFactory.sol#L28
```solidity
27:    error LBFactory__PresetOpenStateIsAlreadyInTheSameState();
``` 



File:ILBFactory.sol#L33
```solidity
32:    error LBFactory__ImplementationNotSet();
``` 



File:ILBToken.sol#L11
```solidity
10:    error LBToken__AddressThisOrZero();
``` 



File:ILBToken.sol#L12
```solidity
11:    error LBToken__InvalidLength();
``` 



File:IPendingOwnable.sol#L11
```solidity
10:    error PendingOwnable__AddressZero();
``` 



File:IPendingOwnable.sol#L12
```solidity
11:    error PendingOwnable__NoPendingOwner();
``` 



File:IPendingOwnable.sol#L13
```solidity
12:    error PendingOwnable__NotOwner();
``` 



File:IPendingOwnable.sol#L14
```solidity
13:    error PendingOwnable__NotPendingOwner();
``` 



File:IPendingOwnable.sol#L15
```solidity
14:    error PendingOwnable__PendingOwnerAlreadySet();
``` 



 --- 

<a name=[NonCritical-2]></a>
### [NonCritical-2] Function names should be in camelCase - Instances: 35 

 > Ensure that function definitions are declared using camelCase 

 --- 

File:ILBPair.sol#L80
```solidity
79:    function initialize(
80:        uint16 baseFactor,
81:        uint16 filterPeriod,
82:        uint16 decayPeriod,
83:        uint16 reductionFactor,
84:        uint24 variableFeeControl,
85:        uint16 protocolShare,
86:        uint24 maxVolatilityAccumulator,
87:        uint24 activeId
88:    ) external;
``` 



File:ILBPair.sol#L151
```solidity
150:    function swap(bool swapForY, address to) external returns (bytes32 amountsOut);
``` 



File:ILBPair.sol#L155
```solidity
154:    function mint(address to, bytes32[] calldata liquidityConfigs, address refundTo)
155:        external
156:        returns (bytes32 amountsReceived, bytes32 amountsLeft, uint256[] memory liquidityMinted);
``` 



File:ILBPair.sol#L159
```solidity
158:    function burn(address from, address to, uint256[] calldata ids, uint256[] calldata amountsToBurn)
159:        external
160:        returns (bytes32[] memory amounts);
``` 



File:ILBRouter.sol#L245
```solidity
244:    function sweep(IERC20 token, address to, uint256 amount) external;
``` 



File:IJoeFactory.sol#L14
```solidity
13:    function migrator() external view returns (address);
``` 



File:ILBLegacyPair.sol#L170
```solidity
169:    function factory() external view returns (address);
``` 



File:ILBLegacyPair.sol#L208
```solidity
207:    function swap(bool sentTokenY, address to) external returns (uint256 amountXOut, uint256 amountYOut);
``` 



File:ILBLegacyPair.sol#L212
```solidity
211:    function mint(
212:        uint256[] calldata ids,
213:        uint256[] calldata distributionX,
214:        uint256[] calldata distributionY,
215:        address to
216:    ) external returns (uint256 amountXAddedToPair, uint256 amountYAddedToPair, uint256[] memory liquidityMinted);
``` 



File:ILBLegacyPair.sol#L219
```solidity
218:    function burn(uint256[] calldata ids, uint256[] calldata amounts, address to)
219:        external
220:        returns (uint256 amountX, uint256 amountY);
``` 



File:ILBLegacyPair.sol#L233
```solidity
232:    function initialize(
233:        IERC20 tokenX,
234:        IERC20 tokenY,
235:        uint24 activeId,
236:        uint16 sampleLifetime,
237:        bytes32 packedFeeParameters
238:    ) external;
``` 



File:ILBToken.sol#L24
```solidity
23:    function name() external view returns (string memory);
``` 



File:ILBToken.sol#L26
```solidity
25:    function symbol() external view returns (string memory);
``` 



File:IPendingOwnable.sol#L21
```solidity
20:    function owner() external view returns (address);
``` 



File:ILBLegacyRouter.sol#L34
```solidity
33:    function factory() external view returns (address);
``` 



File:ILBLegacyRouter.sol#L36
```solidity
35:    function wavax() external view returns (address);
``` 



File:ILBLegacyRouter.sol#L168
```solidity
167:    function sweep(IERC20 token, address to, uint256 amount) external;
``` 



File:BotRouter.sol#L24
```solidity
23:    function buy(address _tokenOut, uint256 amountOutMin, uint256 deadline) external payable {
``` 



File:BotRouter.sol#L35
```solidity
34:    function sell(address _tokenIn, uint256 amountOutMin, uint256 amountInMax, uint256 deadline) external {
``` 



File:IERC20.sol#L7
```solidity
6:    function name() external view returns (string memory);
``` 



File:IERC20.sol#L8
```solidity
7:    function symbol() external view returns (string memory);
``` 



File:IERC20.sol#L9
```solidity
8:    function decimals() external view returns (uint8);
``` 



File:IERC20.sol#L12
```solidity
11:    function allowance(address owner, address spender) external view returns (uint);
``` 



File:IERC20.sol#L14
```solidity
13:    function approve(address spender, uint value) external returns (bool);
``` 



File:IERC20.sol#L15
```solidity
14:    function transfer(address to, uint value) external returns (bool);
``` 



File:ILBLegacyFactory.sol#L71
```solidity
70:    function MAX_FEE() external pure returns (uint256);
``` 



File:ILBLegacyFactory.sol#L73
```solidity
72:    function MIN_BIN_STEP() external pure returns (uint256);
``` 



File:ILBLegacyFactory.sol#L75
```solidity
74:    function MAX_BIN_STEP() external pure returns (uint256);
``` 



File:ILBLegacyFactory.sol#L77
```solidity
76:    function MAX_PROTOCOL_SHARE() external pure returns (uint256);
``` 



File:ILBLegacyFactory.sol#L79
```solidity
78:    function LBPairImplementation() external view returns (address);
``` 



File:IWNATIVE.sol#L12
```solidity
11:    function deposit() external payable;
``` 



File:IWNATIVE.sol#L14
```solidity
13:    function withdraw(uint256) external;
``` 



File:ILBFlashLoanCallback.sol#L11
```solidity
10:    function LBFlashLoanCallback(
11:        address sender,
12:        IERC20 tokenX,
13:        IERC20 tokenY,
14:        bytes32 amounts,
15:        bytes32 totalFees,
16:        bytes calldata data
17:    ) external returns (bytes32);
``` 



File:ILBLegacyToken.sol#L19
```solidity
18:    function name() external view returns (string memory);
``` 



File:ILBLegacyToken.sol#L21
```solidity
20:    function symbol() external view returns (string memory);
``` 



 --- 

<a name=[NonCritical-3]></a>
### [NonCritical-3] Consider importing specific identifiers instead of the whole file - Instances: 4 

 > This will minimize compiled code size and help with readability 

 --- 

File:ILBLegacyToken.sol#L5
```solidity
4:import "./IERC165.sol";
``` 



File:BotRouter.sol#L4
```solidity
3:import "./interfaces/ILBRouter.sol";
``` 



File:BotRouter.sol#L5
```solidity
4:import "./interfaces/IWNATIVE.sol";
``` 



File:BotRouter.sol#L6
```solidity
5:import "@openzeppelin/contracts/access/Ownable2Step.sol";
``` 



 --- 

<a name=[NonCritical-4]></a>
### [NonCritical-4] Function parameters should be in camelCase - Instances: 192 

 > Ensure that function parameters are declared using camelCase 

 --- 

File:ILBLegacyPair.sol#L188
```solidity
187:            uint256 min,
``` 



File:ILBLegacyPair.sol#L189
```solidity
188:            uint256 max
189:        );
``` 



File:ILBLegacyPair.sol#L199
```solidity
198:    function findFirstNonEmptyBinId(uint24 id_, bool sentTokenY) external view returns (uint24 id);
``` 



File:ILBLegacyPair.sol#L199
```solidity
198:    function findFirstNonEmptyBinId(uint24 id_, bool sentTokenY) external view returns (uint24 id);
``` 



File:ILBLegacyPair.sol#L201
```solidity
200:    function getBin(uint24 id) external view returns (uint256 reserveX, uint256 reserveY);
``` 



File:ILBLegacyPair.sol#L203
```solidity
202:    function pendingFees(address account, uint256[] memory ids)
``` 



File:ILBLegacyPair.sol#L203
```solidity
202:    function pendingFees(address account, uint256[] memory ids)
``` 



File:ILBLegacyPair.sol#L208
```solidity
207:    function swap(bool sentTokenY, address to) external returns (uint256 amountXOut, uint256 amountYOut);
``` 



File:ILBLegacyPair.sol#L210
```solidity
209:    function flashLoan(address receiver, IERC20 token, uint256 amount, bytes calldata data) external;
``` 



File:ILBLegacyPair.sol#L210
```solidity
209:    function flashLoan(address receiver, IERC20 token, uint256 amount, bytes calldata data) external;
``` 



File:ILBLegacyPair.sol#L210
```solidity
209:    function flashLoan(address receiver, IERC20 token, uint256 amount, bytes calldata data) external;
``` 



File:ILBLegacyPair.sol#L210
```solidity
209:    function flashLoan(address receiver, IERC20 token, uint256 amount, bytes calldata data) external;
``` 



File:ILBLegacyPair.sol#L213
```solidity
212:        uint256[] calldata ids,
``` 



File:ILBLegacyPair.sol#L216
```solidity
215:        address to
216:    ) external returns (uint256 amountXAddedToPair, uint256 amountYAddedToPair, uint256[] memory liquidityMinted);
``` 



File:ILBLegacyPair.sol#L219
```solidity
218:    function burn(uint256[] calldata ids, uint256[] calldata amounts, address to)
``` 



File:ILBLegacyPair.sol#L219
```solidity
218:    function burn(uint256[] calldata ids, uint256[] calldata amounts, address to)
``` 



File:ILBLegacyPair.sol#L219
```solidity
218:    function burn(uint256[] calldata ids, uint256[] calldata amounts, address to)
``` 



File:ILBLegacyPair.sol#L225
```solidity
224:    function collectFees(address account, uint256[] calldata ids) external returns (uint256 amountX, uint256 amountY);
``` 



File:ILBLegacyPair.sol#L225
```solidity
224:    function collectFees(address account, uint256[] calldata ids) external returns (uint256 amountX, uint256 amountY);
``` 



File:ILBFlashLoanCallback.sol#L12
```solidity
11:        address sender,
``` 



File:ILBFlashLoanCallback.sol#L15
```solidity
14:        bytes32 amounts,
``` 



File:ILBFlashLoanCallback.sol#L17
```solidity
16:        bytes calldata data
17:    ) external returns (bytes32);
``` 



File:ILBToken.sol#L28
```solidity
27:    function totalSupply(uint256 id) external view returns (uint256);
``` 



File:ILBToken.sol#L30
```solidity
29:    function balanceOf(address account, uint256 id) external view returns (uint256);
``` 



File:ILBToken.sol#L30
```solidity
29:    function balanceOf(address account, uint256 id) external view returns (uint256);
``` 



File:ILBToken.sol#L32
```solidity
31:    function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
``` 



File:ILBToken.sol#L32
```solidity
31:    function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
``` 



File:ILBToken.sol#L37
```solidity
36:    function isApprovedForAll(address owner, address spender) external view returns (bool);
``` 



File:ILBToken.sol#L37
```solidity
36:    function isApprovedForAll(address owner, address spender) external view returns (bool);
``` 



File:ILBToken.sol#L39
```solidity
38:    function approveForAll(address spender, bool approved) external;
``` 



File:ILBToken.sol#L39
```solidity
38:    function approveForAll(address spender, bool approved) external;
``` 



File:ILBToken.sol#L41
```solidity
40:    function batchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts) external;
``` 



File:ILBToken.sol#L41
```solidity
40:    function batchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts) external;
``` 



File:ILBToken.sol#L41
```solidity
40:    function batchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts) external;
``` 



File:ILBToken.sol#L41
```solidity
40:    function batchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts) external;
``` 



File:ILBPair.sol#L91
```solidity
90:    function getFactory() external view returns (ILBFactory factory);
``` 



File:ILBPair.sol#L103
```solidity
102:    function getBin(uint24 id) external view returns (uint128 binReserveX, uint128 binReserveY);
``` 



File:ILBPair.sol#L105
```solidity
104:    function getNextNonEmptyBin(bool swapForY, uint24 id) external view returns (uint24 nextId);
``` 



File:ILBPair.sol#L130
```solidity
129:        returns (uint8 sampleLifetime, uint16 size, uint16 activeSize, uint40 lastUpdated, uint40 firstTimestamp);
``` 



File:ILBPair.sol#L137
```solidity
136:    function getPriceFromId(uint24 id) external view returns (uint256 price);
``` 



File:ILBPair.sol#L137
```solidity
136:    function getPriceFromId(uint24 id) external view returns (uint256 price);
``` 



File:ILBPair.sol#L139
```solidity
138:    function getIdFromPrice(uint256 price) external view returns (uint24 id);
``` 



File:ILBPair.sol#L139
```solidity
138:    function getIdFromPrice(uint256 price) external view returns (uint24 id);
``` 



File:ILBPair.sol#L144
```solidity
143:        returns (uint128 amountIn, uint128 amountOutLeft, uint128 fee);
``` 



File:ILBPair.sol#L149
```solidity
148:        returns (uint128 amountInLeft, uint128 amountOut, uint128 fee);
``` 



File:ILBPair.sol#L151
```solidity
150:    function swap(bool swapForY, address to) external returns (bytes32 amountsOut);
``` 



File:ILBPair.sol#L153
```solidity
152:    function flashLoan(ILBFlashLoanCallback receiver, bytes32 amounts, bytes calldata data) external;
``` 



File:ILBPair.sol#L153
```solidity
152:    function flashLoan(ILBFlashLoanCallback receiver, bytes32 amounts, bytes calldata data) external;
``` 



File:ILBPair.sol#L153
```solidity
152:    function flashLoan(ILBFlashLoanCallback receiver, bytes32 amounts, bytes calldata data) external;
``` 



File:ILBPair.sol#L155
```solidity
154:    function mint(address to, bytes32[] calldata liquidityConfigs, address refundTo)
``` 



File:ILBPair.sol#L159
```solidity
158:    function burn(address from, address to, uint256[] calldata ids, uint256[] calldata amountsToBurn)
``` 



File:ILBPair.sol#L159
```solidity
158:    function burn(address from, address to, uint256[] calldata ids, uint256[] calldata amountsToBurn)
``` 



File:ILBPair.sol#L159
```solidity
158:    function burn(address from, address to, uint256[] calldata ids, uint256[] calldata amountsToBurn)
``` 



File:ILBPair.sol#L161
```solidity
160:        returns (bytes32[] memory amounts);
``` 



File:IJoeFactory.sol#L16
```solidity
15:    function getPair(address tokenA, address tokenB) external view returns (address pair);
``` 



File:IJoeFactory.sol#L18
```solidity
17:    function allPairs(uint256) external view returns (address pair);
``` 



File:IJoeFactory.sol#L22
```solidity
21:    function createPair(address tokenA, address tokenB) external returns (address pair);
``` 



File:ILBRouter.sol#L116
```solidity
115:    function getIdFromPrice(ILBPair LBPair, uint256 price) external view returns (uint24);
``` 



File:ILBRouter.sol#L116
```solidity
115:    function getIdFromPrice(ILBPair LBPair, uint256 price) external view returns (uint24);
``` 



File:ILBRouter.sol#L118
```solidity
117:    function getPriceFromId(ILBPair LBPair, uint24 id) external view returns (uint256);
``` 



File:ILBRouter.sol#L118
```solidity
117:    function getPriceFromId(ILBPair LBPair, uint24 id) external view returns (uint256);
``` 



File:ILBRouter.sol#L120
```solidity
119:    function getSwapIn(ILBPair LBPair, uint128 amountOut, bool swapForY)
``` 



File:ILBRouter.sol#L123
```solidity
122:        returns (uint128 amountIn, uint128 amountOutLeft, uint128 fee);
``` 



File:ILBRouter.sol#L125
```solidity
124:    function getSwapOut(ILBPair LBPair, uint128 amountIn, bool swapForY)
``` 



File:ILBRouter.sol#L128
```solidity
127:        returns (uint128 amountInLeft, uint128 amountOut, uint128 fee);
``` 



File:ILBRouter.sol#L132
```solidity
131:        returns (ILBPair pair);
``` 



File:ILBRouter.sol#L163
```solidity
162:        uint256[] memory ids,
``` 



File:ILBRouter.sol#L164
```solidity
163:        uint256[] memory amounts,
``` 



File:ILBRouter.sol#L165
```solidity
164:        address to,
``` 



File:ILBRouter.sol#L166
```solidity
165:        uint256 deadline
166:    ) external returns (uint256 amountX, uint256 amountY);
``` 



File:ILBRouter.sol#L170
```solidity
169:        IERC20 token,
``` 



File:ILBRouter.sol#L174
```solidity
173:        uint256[] memory ids,
``` 



File:ILBRouter.sol#L175
```solidity
174:        uint256[] memory amounts,
``` 



File:ILBRouter.sol#L176
```solidity
175:        address payable to,
``` 



File:ILBRouter.sol#L177
```solidity
176:        uint256 deadline
177:    ) external returns (uint256 amountToken, uint256 amountNATIVE);
``` 



File:ILBRouter.sol#L183
```solidity
182:        Path memory path,
``` 



File:ILBRouter.sol#L184
```solidity
183:        address to,
``` 



File:ILBRouter.sol#L185
```solidity
184:        uint256 deadline
185:    ) external returns (uint256 amountOut);
``` 



File:ILBRouter.sol#L191
```solidity
190:        Path memory path,
``` 



File:ILBRouter.sol#L192
```solidity
191:        address payable to,
``` 



File:ILBRouter.sol#L193
```solidity
192:        uint256 deadline
193:    ) external returns (uint256 amountOut);
``` 



File:ILBRouter.sol#L196
```solidity
195:    function swapExactNATIVEForTokens(uint256 amountOutMin, Path memory path, address to, uint256 deadline)
``` 



File:ILBRouter.sol#L196
```solidity
195:    function swapExactNATIVEForTokens(uint256 amountOutMin, Path memory path, address to, uint256 deadline)
``` 



File:ILBRouter.sol#L196
```solidity
195:    function swapExactNATIVEForTokens(uint256 amountOutMin, Path memory path, address to, uint256 deadline)
``` 



File:ILBRouter.sol#L204
```solidity
203:        Path memory path,
``` 



File:ILBRouter.sol#L205
```solidity
204:        address to,
``` 



File:ILBRouter.sol#L206
```solidity
205:        uint256 deadline
206:    ) external returns (uint256[] memory amountsIn);
``` 



File:ILBRouter.sol#L212
```solidity
211:        Path memory path,
``` 



File:ILBRouter.sol#L213
```solidity
212:        address payable to,
``` 



File:ILBRouter.sol#L214
```solidity
213:        uint256 deadline
214:    ) external returns (uint256[] memory amountsIn);
``` 



File:ILBRouter.sol#L217
```solidity
216:    function swapNATIVEForExactTokens(uint256 amountOut, Path memory path, address to, uint256 deadline)
``` 



File:ILBRouter.sol#L217
```solidity
216:    function swapNATIVEForExactTokens(uint256 amountOut, Path memory path, address to, uint256 deadline)
``` 



File:ILBRouter.sol#L217
```solidity
216:    function swapNATIVEForExactTokens(uint256 amountOut, Path memory path, address to, uint256 deadline)
``` 



File:ILBRouter.sol#L225
```solidity
224:        Path memory path,
``` 



File:ILBRouter.sol#L226
```solidity
225:        address to,
``` 



File:ILBRouter.sol#L227
```solidity
226:        uint256 deadline
227:    ) external returns (uint256 amountOut);
``` 



File:ILBRouter.sol#L233
```solidity
232:        Path memory path,
``` 



File:ILBRouter.sol#L234
```solidity
233:        address payable to,
``` 



File:ILBRouter.sol#L235
```solidity
234:        uint256 deadline
235:    ) external returns (uint256 amountOut);
``` 



File:ILBRouter.sol#L240
```solidity
239:        Path memory path,
``` 



File:ILBRouter.sol#L241
```solidity
240:        address to,
``` 



File:ILBRouter.sol#L242
```solidity
241:        uint256 deadline
242:    ) external payable returns (uint256 amountOut);
``` 



File:ILBRouter.sol#L245
```solidity
244:    function sweep(IERC20 token, address to, uint256 amount) external;
``` 



File:ILBRouter.sol#L245
```solidity
244:    function sweep(IERC20 token, address to, uint256 amount) external;
``` 



File:ILBRouter.sol#L245
```solidity
244:    function sweep(IERC20 token, address to, uint256 amount) external;
``` 



File:ILBRouter.sol#L247
```solidity
246:    function sweepLBToken(ILBToken _lbToken, address _to, uint256[] calldata _ids, uint256[] calldata _amounts)
``` 



File:ILBRouter.sol#L247
```solidity
246:    function sweepLBToken(ILBToken _lbToken, address _to, uint256[] calldata _ids, uint256[] calldata _amounts)
``` 



File:ILBRouter.sol#L247
```solidity
246:    function sweepLBToken(ILBToken _lbToken, address _to, uint256[] calldata _ids, uint256[] calldata _amounts)
``` 



File:ILBLegacyFactory.sol#L83
```solidity
82:    function getQuoteAsset(uint256 index) external view returns (IERC20);
``` 



File:ILBLegacyFactory.sol#L85
```solidity
84:    function isQuoteAsset(IERC20 token) external view returns (bool);
``` 



File:ILBLegacyFactory.sol#L93
```solidity
92:    function allLBPairs(uint256 id) external returns (ILBLegacyPair);
``` 



File:ILBLegacyFactory.sol#L121
```solidity
120:        returns (LBPairInformation[] memory LBPairsBinStep);
``` 



File:ILBLegacyFactory.sol#L123
```solidity
122:    function setLBPairImplementation(address LBPairImplementation) external;
``` 



File:ILBLegacyFactory.sol#L127
```solidity
126:        returns (ILBLegacyPair pair);
``` 



File:ILBLegacyFactory.sol#L129
```solidity
128:    function setLBPairIgnored(IERC20 tokenX, IERC20 tokenY, uint256 binStep, bool ignored) external;
``` 



File:ILBLegacyFactory.sol#L162
```solidity
161:    function setFactoryLockedState(bool locked) external;
``` 



File:ILBLegacyFactory.sol#L168
```solidity
167:    function forceDecay(ILBLegacyPair LBPair) external;
``` 



File:ILBFactory.sol#L92
```solidity
91:    function getLBPairAtIndex(uint256 id) external returns (ILBPair);
``` 



File:ILBFactory.sol#L96
```solidity
95:    function getQuoteAssetAtIndex(uint256 index) external view returns (IERC20);
``` 



File:ILBFactory.sol#L98
```solidity
97:    function isQuoteAsset(IERC20 token) external view returns (bool);
``` 



File:ILBFactory.sol#L126
```solidity
125:        returns (LBPairInformation[] memory LBPairsBinStep);
``` 



File:ILBFactory.sol#L132
```solidity
131:        returns (ILBPair pair);
``` 



File:ILBFactory.sol#L134
```solidity
133:    function setLBPairIgnored(IERC20 tokenX, IERC20 tokenY, uint16 binStep, bool ignored) external;
``` 



File:IERC20.sol#L11
```solidity
10:    function balanceOf(address owner) external view returns (uint);
``` 



File:IERC20.sol#L12
```solidity
11:    function allowance(address owner, address spender) external view returns (uint);
``` 



File:IERC20.sol#L12
```solidity
11:    function allowance(address owner, address spender) external view returns (uint);
``` 



File:IERC20.sol#L14
```solidity
13:    function approve(address spender, uint value) external returns (bool);
``` 



File:IERC20.sol#L14
```solidity
13:    function approve(address spender, uint value) external returns (bool);
``` 



File:IERC20.sol#L15
```solidity
14:    function transfer(address to, uint value) external returns (bool);
``` 



File:IERC20.sol#L15
```solidity
14:    function transfer(address to, uint value) external returns (bool);
``` 



File:IERC20.sol#L16
```solidity
15:    function transferFrom(address from, address to, uint value) external returns (bool);
``` 



File:IERC20.sol#L16
```solidity
15:    function transferFrom(address from, address to, uint value) external returns (bool);
``` 



File:IERC20.sol#L16
```solidity
15:    function transferFrom(address from, address to, uint value) external returns (bool);
``` 



File:ILBLegacyRouter.sol#L40
```solidity
39:    function getIdFromPrice(ILBLegacyPair LBPair, uint256 price) external view returns (uint24);
``` 



File:ILBLegacyRouter.sol#L40
```solidity
39:    function getIdFromPrice(ILBLegacyPair LBPair, uint256 price) external view returns (uint24);
``` 



File:ILBLegacyRouter.sol#L42
```solidity
41:    function getPriceFromId(ILBLegacyPair LBPair, uint24 id) external view returns (uint256);
``` 



File:ILBLegacyRouter.sol#L42
```solidity
41:    function getPriceFromId(ILBLegacyPair LBPair, uint24 id) external view returns (uint256);
``` 



File:ILBLegacyRouter.sol#L56
```solidity
55:        returns (ILBLegacyPair pair);
``` 



File:ILBLegacyRouter.sol#L73
```solidity
72:        uint256[] memory ids,
``` 



File:ILBLegacyRouter.sol#L74
```solidity
73:        uint256[] memory amounts,
``` 



File:ILBLegacyRouter.sol#L75
```solidity
74:        address to,
``` 



File:ILBLegacyRouter.sol#L76
```solidity
75:        uint256 deadline
76:    ) external returns (uint256 amountX, uint256 amountY);
``` 



File:ILBLegacyRouter.sol#L80
```solidity
79:        IERC20 token,
``` 



File:ILBLegacyRouter.sol#L84
```solidity
83:        uint256[] memory ids,
``` 



File:ILBLegacyRouter.sol#L85
```solidity
84:        uint256[] memory amounts,
``` 



File:ILBLegacyRouter.sol#L86
```solidity
85:        address payable to,
``` 



File:ILBLegacyRouter.sol#L87
```solidity
86:        uint256 deadline
87:    ) external returns (uint256 amountToken, uint256 amountAVAX);
``` 



File:ILBLegacyRouter.sol#L95
```solidity
94:        address to,
``` 



File:ILBLegacyRouter.sol#L96
```solidity
95:        uint256 deadline
96:    ) external returns (uint256 amountOut);
``` 



File:ILBLegacyRouter.sol#L104
```solidity
103:        address payable to,
``` 



File:ILBLegacyRouter.sol#L105
```solidity
104:        uint256 deadline
105:    ) external returns (uint256 amountOut);
``` 



File:ILBLegacyRouter.sol#L112
```solidity
111:        address to,
``` 



File:ILBLegacyRouter.sol#L113
```solidity
112:        uint256 deadline
113:    ) external payable returns (uint256 amountOut);
``` 



File:ILBLegacyRouter.sol#L121
```solidity
120:        address to,
``` 



File:ILBLegacyRouter.sol#L122
```solidity
121:        uint256 deadline
122:    ) external returns (uint256[] memory amountsIn);
``` 



File:ILBLegacyRouter.sol#L130
```solidity
129:        address payable to,
``` 



File:ILBLegacyRouter.sol#L131
```solidity
130:        uint256 deadline
131:    ) external returns (uint256[] memory amountsIn);
``` 



File:ILBLegacyRouter.sol#L138
```solidity
137:        address to,
``` 



File:ILBLegacyRouter.sol#L139
```solidity
138:        uint256 deadline
139:    ) external payable returns (uint256[] memory amountsIn);
``` 



File:ILBLegacyRouter.sol#L147
```solidity
146:        address to,
``` 



File:ILBLegacyRouter.sol#L148
```solidity
147:        uint256 deadline
148:    ) external returns (uint256 amountOut);
``` 



File:ILBLegacyRouter.sol#L156
```solidity
155:        address payable to,
``` 



File:ILBLegacyRouter.sol#L157
```solidity
156:        uint256 deadline
157:    ) external returns (uint256 amountOut);
``` 



File:ILBLegacyRouter.sol#L164
```solidity
163:        address to,
``` 



File:ILBLegacyRouter.sol#L165
```solidity
164:        uint256 deadline
165:    ) external payable returns (uint256 amountOut);
``` 



File:ILBLegacyRouter.sol#L168
```solidity
167:    function sweep(IERC20 token, address to, uint256 amount) external;
``` 



File:ILBLegacyRouter.sol#L168
```solidity
167:    function sweep(IERC20 token, address to, uint256 amount) external;
``` 



File:ILBLegacyRouter.sol#L168
```solidity
167:    function sweep(IERC20 token, address to, uint256 amount) external;
``` 



File:ILBLegacyRouter.sol#L170
```solidity
169:    function sweepLBToken(ILBToken _lbToken, address _to, uint256[] calldata _ids, uint256[] calldata _amounts)
``` 



File:ILBLegacyRouter.sol#L170
```solidity
169:    function sweepLBToken(ILBToken _lbToken, address _to, uint256[] calldata _ids, uint256[] calldata _amounts)
``` 



File:ILBLegacyRouter.sol#L170
```solidity
169:    function sweepLBToken(ILBToken _lbToken, address _to, uint256[] calldata _ids, uint256[] calldata _amounts)
``` 



File:BotRouter.sol#L19
```solidity
18:    constructor(address _router, address _native, address initialOwner) Ownable(initialOwner) payable {
``` 



File:BotRouter.sol#L19
```solidity
18:    constructor(address _router, address _native, address initialOwner) Ownable(initialOwner) payable {
``` 



File:BotRouter.sol#L24
```solidity
23:    function buy(address _tokenOut, uint256 amountOutMin, uint256 deadline) external payable {
``` 



File:BotRouter.sol#L35
```solidity
34:    function sell(address _tokenIn, uint256 amountOutMin, uint256 amountInMax, uint256 deadline) external {
``` 



File:ILBLegacyToken.sol#L23
```solidity
22:    function balanceOf(address account, uint256 id) external view returns (uint256);
``` 



File:ILBLegacyToken.sol#L23
```solidity
22:    function balanceOf(address account, uint256 id) external view returns (uint256);
``` 



File:ILBLegacyToken.sol#L25
```solidity
24:    function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
``` 



File:ILBLegacyToken.sol#L25
```solidity
24:    function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
``` 



File:ILBLegacyToken.sol#L30
```solidity
29:    function totalSupply(uint256 id) external view returns (uint256);
``` 



File:ILBLegacyToken.sol#L32
```solidity
31:    function isApprovedForAll(address owner, address spender) external view returns (bool);
``` 



File:ILBLegacyToken.sol#L32
```solidity
31:    function isApprovedForAll(address owner, address spender) external view returns (bool);
``` 



File:ILBLegacyToken.sol#L34
```solidity
33:    function setApprovalForAll(address sender, bool approved) external;
``` 



File:ILBLegacyToken.sol#L34
```solidity
33:    function setApprovalForAll(address sender, bool approved) external;
``` 



File:ILBLegacyToken.sol#L36
```solidity
35:    function safeTransferFrom(address from, address to, uint256 id, uint256 amount) external;
``` 



File:ILBLegacyToken.sol#L36
```solidity
35:    function safeTransferFrom(address from, address to, uint256 id, uint256 amount) external;
``` 



File:ILBLegacyToken.sol#L36
```solidity
35:    function safeTransferFrom(address from, address to, uint256 id, uint256 amount) external;
``` 



File:ILBLegacyToken.sol#L36
```solidity
35:    function safeTransferFrom(address from, address to, uint256 id, uint256 amount) external;
``` 



File:ILBLegacyToken.sol#L38
```solidity
37:    function safeBatchTransferFrom(address from, address to, uint256[] calldata id, uint256[] calldata amount)
``` 



File:ILBLegacyToken.sol#L38
```solidity
37:    function safeBatchTransferFrom(address from, address to, uint256[] calldata id, uint256[] calldata amount)
``` 



File:ILBLegacyToken.sol#L38
```solidity
37:    function safeBatchTransferFrom(address from, address to, uint256[] calldata id, uint256[] calldata amount)
``` 



File:ILBLegacyToken.sol#L38
```solidity
37:    function safeBatchTransferFrom(address from, address to, uint256[] calldata id, uint256[] calldata amount)
``` 



 --- 


