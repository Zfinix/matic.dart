
 import 'package:matic_dart/interfaces/contract_init_param.dart';
import 'package:matic_dart/interfaces/pos_client_config.dart';
import 'package:matic_dart/interfaces/pos_contracts.dart';
import 'package:matic_dart/utils/base_token.dart';
import 'package:matic_dart/utils/web3_side_chain_client.dart';

class POSToken extends BaseToken<IPOSClientConfig> {

    final  String predicateAddress;
    final IContractInitParam contractParam;
    final Web3SideChainClient<IPOSClientConfig> client;
    final IPOSContracts getPOSContracts;

    POSToken( {
        required this.predicateAddress,
        required this.contractParam,
     required   this.client ,
     required   this.getPOSContracts ,
    }):super(contractParam: contractParam, client: client,);

     get rootChainManager {
        return this.getPOSContracts.rootChainManager;
    }

     get exitUtil {
        return this.getPOSContracts.exitUtil;
    }


   Future<String>  getPredicateAddress() async{
        if (predicateAddress.isNotEmpty) {
            return Future.value(this.predicateAddress);
        }
        return this.rootChainManager.method(
            "tokenToType",
            this.contractParam.address
        ).then(method => {
            return method.read();
        }).then(tokenType => {
            if (!tokenType) {
                throw new Error('Invalid Token Type');
            }
            return this.rootChainManager.method(
                "typeToPredicate", tokenType
            );
        }).then(typeToPredicateMethod => {
            return typeToPredicateMethod.read<string>();
        }).then(predicateAddress => {
            this.predicateAddress = predicateAddress;
            return predicateAddress;
        });
    }

    protected isWithdrawn(txHash: string, eventSignature: string) {
        if (!txHash) {
            throw new Error(`txHash not provided`);
        }
        return this.exitUtil.getExitHash(
            txHash, eventSignature
        ).then(exitHash => {
            return this.rootChainManager.isExitProcessed(
                exitHash
            );
        });
    }

    protected withdrawExitPOS(burnTxHash: string, eventSignature: string, isFast: boolean, option: ITransactionOption) {
        return this.exitUtil.buildPayloadForExit(
            burnTxHash,
            eventSignature,
            isFast
        ).then(payload => {
            return this.rootChainManager.exit(
                payload, option
            );
        });
    }
}