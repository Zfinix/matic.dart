import 'package:dartz/dartz.dart';
import 'package:matic_dart/constant.dart';
import 'package:matic_dart/index.dart';
import 'package:matic_dart/interfaces/exit_transaction_option.dart';
import 'package:matic_dart/pos/pos_token.dart';
import 'package:web3dart/web3dart.dart';

class ERC20 extends POSToken {
  final EthereumAddress tokenAddress;
  final bool isParent;
  final Web3SideChainClient<IPOSClientConfig> client;
  final IPOSContracts getPOSContracts;

  ERC20({
    required this.client,
    required this.tokenAddress,
    required this.isParent,
    required this.getPOSContracts,
  }) : super(
          contractParam: IContractInitParam(
            isParent: isParent,
            address: tokenAddress,
            name: 'ChildERC20',
            bridgeType: 'pos',
          ),
          getPOSContracts: getPOSContracts,
          client: client,
        );

  Future<dynamic> getBalance(String userAddress,
      [ITransactionOption? option]) async {
    final contract = await getContract();

    final method = contract?.method("balanceOf", [userAddress]);
    return this.processRead<String>(method!, option);
  }

  /**
     * get allowance of user
     *
     * @param {string} userAddress
     * @param {ITransactionOption} [option]
     * @returns
     * @memberof ERC20
     */
  Future getAllowance(String userAddress,
      [IAllowanceTransactionOption option =
          IAllowanceTransactionOption.empty]) async {
    final spenderAddress = option.spenderAddress;

    final address = spenderAddress.isNotEmpty
        ? spenderAddress
        : await getPredicateAddress();
    final contract = await getContract();

    final method = contract?.method("allowance", [
      userAddress,
      address,
    ]);
    return await this.processRead<String>(method!, option);
  }

  approve(BigInt amount,
      [IApproveTransactionOption option =
          IApproveTransactionOption.empty]) async {
    final spenderAddress = option.spenderAddress;

    if (spenderAddress.isEmpty && !this.contractParam.isParent) {
      this.client.logger.error(ERROR_TYPE.nullSpenderAddress).throwException();
    }

    final address = spenderAddress.isNotEmpty
        ? spenderAddress
        : await getPredicateAddress();
    final contract = await getContract();

    final method =
        contract?.method("approve", [address, Converter.bigIntToHex(amount)]);

    return await this.processWrite(method!, option);
  }

  approveMax(
      [IApproveTransactionOption option = IApproveTransactionOption.empty]) {
    return approve(MAX_AMOUNT, option);
  }

  /**
     * Deposit given amount of token for user
     *
     * @param {TYPE_AMOUNT} amount
     * @param {string} userAddress
     * @param {ITransactionOption} [option]
     * @returns
     * @memberof ERC20
     */
  deposit(BigInt amount, String userAddress, [ITransactionOption? option]) {
    this.checkForRoot("deposit");

    /*     final amountInABI = this.client.parent.encodeParameters(
            [Converter.bigIntToHex(amount)],
            ['uint256'],
        );
        return this.rootChainManager.deposit(
            userAddress,
            this.contractParam.address,
            amountInABI,
            option
        ); */
  }

  Future<Either<ITransactionWriteResult, ITransactionRequestConfig>>
      depositEther_(
    BigInt amount,
    String userAddress, [
    ITransactionOption option = ITransactionOption.empty,
  ]) async {
    this.checkForRoot("depositEther");

    option = option.copyWith(value: EtherAmount.inWei(amount));

    final method =
        await rootChainManager.method("depositEtherFor", [userAddress]);

    return await processWrite(method!, option);
  }

  /**
     * initiate withdraw by burning provided amount
     *
     * @param {TYPE_AMOUNT} amount
     * @param {ITransactionOption} [option]
     * @returns
     * @memberof ERC20
     */
  Future<Either<ITransactionWriteResult, ITransactionRequestConfig>>
      withdrawStart(BigInt amount, ITransactionOption? option) async {
    this.checkForChild("withdrawStart");

    final contract = await this.getContract();

    final method =
        contract?.method("withdraw", [Converter.bigIntToHex(amount)]);

    return await processWrite(method!, option!);
  }

  Future<Future<Either<ITransactionWriteResult, ITransactionRequestConfig>?>>
      withdrawExit_(
    String burnTransactionHash,
    bool isFast, [
    IExitTransactionOption option = IExitTransactionOption.empty,
  ]) async {
    final eventSignature = option.burnEventSignature.isNotEmpty
        ? option.burnEventSignature
        : LogEventSignature.Erc20Transfer.value;

    final payload = await this
        .exitUtil
        .buildPayloadForExit(burnTransactionHash, eventSignature, isFast);

    return rootChainManager.exit(payload, option);
  }

  /**
     * complete withdraw process after checkpoint has been submitted for the block containing burn tx.
     *
     * @param {string} burnTransactionHash
     * @param {ITransactionOption} [option]
     * @returns
     * @memberof ERC20
     */
  withdrawExit(String burnTransactionHash, [IExitTransactionOption? option]) {
    this.checkForRoot("withdrawExit");

    return this.withdrawExit_(
        burnTransactionHash, false, option ?? IExitTransactionOption.empty);
  }

  /**
     * complete withdraw process after checkpoint has been submitted for the block containing burn tx.
     *
     *  Note:- It create the proof in api call for fast exit.
     * 
     * @param {string} burnTransactionHash
     * @param {ITransactionOption} [option]
     * @returns
     * @memberof ERC20
     */
  withdrawExitFaster(
    String burnTransactionHash, [
    IExitTransactionOption? option,
  ]) {
    this.checkForRoot("withdrawExitFaster");

    return this.withdrawExit_(
        burnTransactionHash, true, option ?? IExitTransactionOption.empty);
  }

  /**
     * check if exit has been completed for a transaction hash
     *
     * @param {string} burnTxHash
     * @returns
     * @memberof ERC20
     */
  isWithdrawExited(String burnTxHash) {
    return isWithdrawn(burnTxHash, LogEventSignature.Erc20Transfer.value);
  }

  /**
     * transfer amount to another user
     *
     * @param {TYPE_AMOUNT} amount
     * @param {string} to
     * @param {ITransactionOption} [option]
     * @returns
     * @memberof ERC20
     */
  dynamic transfer(BigInt amount, String to, ITransactionOption? option) {
    return transferERC20(to, amount, option);
  }
}
