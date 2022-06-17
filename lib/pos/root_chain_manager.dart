import 'package:dartz/dartz.dart';
import 'package:matic_dart/index.dart';
import 'package:web3dart/web3dart.dart';

class RootChainManager extends BaseToken<IPOSClientConfig> {
  RootChainManager(
      Web3SideChainClient<IPOSClientConfig> client_, EthereumAddress address)
      : super(
            contractParam: IContractInitParam(
                address: address,
                name: 'RootChainManager',
                bridgeType: 'pos',
                isParent: true),
            client: client_);

  Future<BaseContractMethod?> method(String methodName, List args) async {
    final contract = await getContract();

    return contract?.method(methodName, args);
  }

  deposit({
    required String userAddress,
    required String tokenAddress,
    required String depositData,
    required ITransactionOption? option,
  }) async {
    final method = await this
        .method("depositFor", [userAddress, tokenAddress, depositData]);
    if (method != null && option != null) {
      return processWrite(method, option);
    }
  }

  Future<Either<ITransactionWriteResult, ITransactionRequestConfig>?> exit(
      String exitPayload, ITransactionOption option,) async {
    final val = await method("exit", [exitPayload]);
    if (val != null) {
      return processWrite(val, option);
    } else {
      return null;
    }
  }

  isExitProcessed(String exitHash) async {
    final val = await method("processedExits", [exitHash]);
    if (val != null) {
      return processRead<bool>(val);
    }
  }
}
