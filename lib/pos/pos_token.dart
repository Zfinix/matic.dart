import 'package:dartz/dartz.dart';
import 'package:matic_dart/index.dart';
import 'package:matic_dart/pos/exit_util.dart';
import 'package:matic_dart/pos/root_chain_manager.dart';

class POSToken extends BaseToken<IPOSClientConfig> {
  String predicateAddress = '';
  final IContractInitParam contractParam;
  final Web3SideChainClient<IPOSClientConfig> client;
  final IPOSContracts getPOSContracts;

  POSToken({
    required this.contractParam,
    required this.client,
    required this.getPOSContracts,
  }) : super(
          contractParam: contractParam,
          client: client,
        );

  RootChainManager get rootChainManager {
    return this.getPOSContracts.rootChainManager;
  }

  ExitUtil get exitUtil {
    return this.getPOSContracts.exitUtil;
  }

  Future<String> getPredicateAddress() async {
    if (predicateAddress.isNotEmpty) {
      return Future.value(this.predicateAddress);
    }

    final method = await this.rootChainManager.method(
      "tokenToType",
      [contractParam.address],
    );

    final tokenType = await method?.read();

    if (!tokenType) {
      throw 'Invalid Token Type';
    }

    final meth = await this.rootChainManager.method(
          "typeToPredicate",
          tokenType,
        );

    final pred = await meth?.read<String>();
    predicateAddress = pred ?? '';
    return pred ?? '';
  }

  isWithdrawn(String txHash, String eventSignature) async {
    if (txHash.isEmpty) {
      throw 'txHash not provided';
    }
    
    final exitHash = await this.exitUtil.getExitHash(
          txHash,
          eventSignature,
        );

    return rootChainManager.isExitProcessed(exitHash);
  }

  Future<Either<ITransactionWriteResult, ITransactionRequestConfig>?>
      withdrawExitPOS(
    String burnTxHash,
    String eventSignature,
    bool isFast,
    ITransactionOption option,
  ) async {
    final payload = await exitUtil.buildPayloadForExit(
      burnTxHash,
      eventSignature,
      isFast,
    );

    return rootChainManager.exit(payload, option);
  }
}
