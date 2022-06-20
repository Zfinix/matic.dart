import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:web3dart/web3dart.dart';
import 'package:matic_dart/index.dart';

class ITransactionConfigParam {
  final ITransactionRequestConfig txConfig;
  final BaseContractMethod? method;
  final bool? isWrite;
  final bool? isParent;

  const ITransactionConfigParam({
    required this.txConfig,
    this.method,
    this.isWrite,
    this.isParent,
  });
}

class BaseToken<T> with EquatableMixin {
  BaseContract? contract_;
  final IContractInitParam contractParam;
  final Web3SideChainClient<T> client;

  BaseToken({
    required this.contractParam,
    required this.client,
  });

  Future<BaseContract?> getContract() async {
    if (contract_ != null) {
      return Future.value(contract_);
    }
    return await this
        .client
        .getABI(
          name: contractParam.name,
          type: contractParam.bridgeType,
        )
        ?.then((abi) {
      /*    contract_ = getContract_(
          abi: abi,
          isParent: contractParam.isParent,
          tokenAddress: contractParam.address); */
      return contract_;
    });
  }

  Future<Either<ITransactionWriteResult, ITransactionRequestConfig>>
      processWrite(
    BaseContractMethod method,
    ITransactionOption option,
  ) async {
    client.logger.log("process write");
    final config = await createTransactionConfig(
      ITransactionConfigParam(
        txConfig: option,
        isWrite: true,
        method: method,
        isParent: contractParam.isParent,
      ),
    );

    client.logger.log("process write config");
    if (option.returnTransaction) {
      return Right(
        config.copyWith(
          data: method.encodeABI(),
          to: method.address,
        ),
      );
    }

    final methodResult = method.write(config);
    return Left(methodResult);
  }

  Future<Either<ITransactionWriteResult, ITransactionRequestConfig>>
      sendTransaction(
    ITransactionOption option,
  ) async {
    final isParent = contractParam.isParent;
    final client = getClient(isParent);
    client.logger.log("process write");

    final config = await createTransactionConfig(ITransactionConfigParam(
      txConfig: option,
      isWrite: true,
      method: null,
      isParent: contractParam.isParent,
    ));

    client.logger.log("process write config");
    if (option.returnTransaction) {
      return Right(config);
    }
    final methodResult = await client.write(config);
    return Left(methodResult);
  }

  Future<Either<String, ITransactionRequestConfig>> readTransaction(
    ITransactionOption option,
  ) async {
    final isParent = contractParam.isParent;
    final client = getClient(isParent);
    client.logger.log("process read");

    final config = await createTransactionConfig(ITransactionConfigParam(
        txConfig: option,
        isWrite: true,
        method: null,
        isParent: contractParam.isParent));

    client.logger.log("write tx config created");

    if (option.returnTransaction) {
      return Right(config);
    }

    return Left(await client.read(config));
  }

  Future<dynamic> processRead<T>(
    BaseContractMethod method, [
    ITransactionOption? option,
  ]) async {
    client.logger.log("process read");

    ITransactionRequestConfig? config;

    client.logger.log("read tx config created");

    if (option != null && option.returnTransaction == true) {
      config = await createTransactionConfig(
        ITransactionConfigParam(
          txConfig: option,
          isWrite: false,
          method: method,
          isParent: contractParam.isParent,
        ),
      );

      return config.copyWith(
        data: method.encodeABI(),
        to: contract_?.address,
      );
    }

    return method.read<T>(config);
  }

  MaticWeb3Client getClient(isParent) {
    return isParent ? client.parent! : client.child!;
  }

  DeployedContract getContract_({
    required bool isParent,
    required EthereumAddress tokenAddress,
    required ContractAbi abi,
  }) {
    final client = getClient(isParent);
    return client.getContract(address: tokenAddress, abi: abi);
  }

  IBaseClientDefaultConfig? get parentDefaultConfig {
    final IBaseClientConfig config = client.config!;
    return config.parent?.defaultConfig;
  }

  IBaseClientDefaultConfig? get childDefaultConfig {
    final IBaseClientConfig config = client.config!;
    return config.child?.defaultConfig;
  }

  Future<ITransactionRequestConfig> createTransactionConfig(
      ITransactionConfigParam param) async {
    final defaultConfig =
        param.isParent == true ? parentDefaultConfig : childDefaultConfig;

    var txConfig = ITransactionRequestConfig.fromMap({
      ...defaultConfig?.toMap() ?? {},
      ...param.txConfig.toMap(),
    });

    final web3Client = param.isParent == true ? client.parent! : client.child!;

    web3Client.logger.log({
      "txConfig": txConfig,
      "onRoot": param.isParent,
      "isWrite": param.isWrite
    });

    final estimateGas = (ITransactionRequestConfig config) {
      return param.method != null
          ? param.method!.estimateGas(config)
          : web3Client.estimateGasUsingConfig(config);
    };
    // txConfig.chainId = Converter.toHex(txConfig.chainId) as any;
    if (param.isWrite == true) {
      final maxFeePerGas = txConfig.maxFeePerGas;
      final maxPriorityFeePerGas = txConfig.maxPriorityFeePerGas;
      final isEIP1559Supported =
          client.isEIP1559Supported(param.isParent == true);
      final isMaxFeeProvided = maxFeePerGas ?? maxPriorityFeePerGas;

      if (!isEIP1559Supported && isMaxFeeProvided != null) {
        web3Client.logger
            .error(ERROR_TYPE.eIP1559NotSupported, '${param.isParent}')
            .throwException();
      }

      final gasLimit = txConfig.gasLimit ??
          await estimateGas(
            ITransactionRequestConfig(
              from: txConfig.from,
              value: txConfig.value,
            ),
          );

      final nonce = txConfig.nonce ??
          await web3Client.getTransactionCount(
            txConfig.from!,
            atBlock: BlockNum.pending(),
          );

      final chainId = txConfig.chainId ?? await web3Client.getChainId();

      client.logger.log("options filled");

      return txConfig.copyWith(
        gasLimit: gasLimit,
        nonce: nonce,
        chainId: chainId,
      );
    }
    return Future.value(param.txConfig);
  }

  transferERC20(String to, BigInt amount, ITransactionOption? option) {
    return getContract().then((contract) async {
      final method = await contract
          ?.method("transfer", [to, Converter.bigIntToHex(amount)]);
      return processWrite(method!, option!);
    });
  }

  transferERC721(
      String from, String to, String tokenId, ITransactionOption option) {
    return getContract().then((contract) {
      final method = contract?.method("transferFrom", [from, to, tokenId]);
      return processWrite(method!, option);
    });
  }

  checkForRoot(methodName) {
    if (!contractParam.isParent) {
      throw client.logger.error(ERROR_TYPE.allowedOnRoot, methodName);
    }
  }

  checkForChild(methodName) {
    if (contractParam.isParent) {
      throw client.logger.error(ERROR_TYPE.allowedOnRoot, methodName);
    }
  }

  transferERC1155(POSERC1155TransferParam param, ITransactionOption option) {
    /*   return getContract().then((contract){
            final method = contract.method(
                "safeTransferFrom",
              [  param.from,
                param.to,
                Converter.toHex(param.tokenId),
                Converter.toHex(param.amount),
                param.data || '0x']
            );
            return processWrite(
                method, option
            );
        }); */
  }

  @override
  List<Object> get props => [contract_ ?? '', contractParam, client];
}
