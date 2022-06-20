import 'package:matic_dart/index.dart';
import 'package:matic_dart/pos/exit_util.dart';

class BridgeClient<T> {
  var client = Web3SideChainClient<T>();

  ExitUtil exitUtil;
  BridgeClient({
    required this.exitUtil,
  });

  /**
     * check whether a txHash is checkPointed 
     *
     * @param {string} txHash
     * @returns
     * @memberof BridgeClient
     */
  Future<bool> isCheckPointed(String txHash) {
    return this.exitUtil.isCheckPointed(txHash);
  }

  isDeposited(String depositTxHash) async {
    final client = this.client;

    final token = new BaseToken(
      contractParam: IContractInitParam(
          address: client.abiManager
              ?.getConfig("Matic.GenesisContracts.StateReceiver"),
          isParent: false,
          name: 'StateReceiver',
          bridgeType: 'genesis'),
      client: client,
    );

    final contract = await token.getContract();
    print(contract);

    /* 
        
     
            final receipt =     await client.parent?.getTransactionReceipt(depositTxHash);
            final lastStateId =  token['processRead']<String>(
                    contract.method("lastStateId")
                );
            final eventSignature = '0x103fed9db65eac19c4d870f49ab7520fe03b99f1838e5996caf47e9e43308392';
            final targetLog = receipt.logs.find((q) => q.topics[0] == eventSignature);
            
            if (!targetLog) {
                throw "StateSynced event not found";
            }
            final rootStateId = client.child.decodeParameters(targetLog.topics[1], ['uint256'])[0];
            final rootStateIdBN = utils.BN.isBN(rootStateId) ? rootStateId : new utils.BN(rootStateId);
            return lastStateId>=rootStateIdBN; */
  }
}
