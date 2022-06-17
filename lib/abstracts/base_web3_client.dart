/* import 'package:matic_dart/abstracts/index.dart';
import 'package:matic_dart/interfaces/block.dart';
import 'package:matic_dart/interfaces/block_with_transaction.dart';
import 'package:matic_dart/interfaces/rpc_request_payload.dart';
import 'package:matic_dart/interfaces/rpc_response_payload.dart';
import 'package:matic_dart/interfaces/transaction_config.dart';
import 'package:matic_dart/interfaces/transaction_data.dart';
import 'package:matic_dart/interfaces/transaction_write_result.dart';
import 'package:matic_dart/utils/logger.dart';
import 'package:web3dart/web3dart.dart';

 abstract class BaseWeb3Client implements Web3Client {
  final Logger logger;

  const BaseWeb3Client({required this.logger});

  BaseContract getContract({
    required String address,
    required dynamic abi,
  });

  Future<String> read(ITransactionRequestConfig config);

  ITransactionWriteResult write(ITransactionRequestConfig config);

  Future<ITransactionData> getTransaction(String transactionHash);

  //Future<ITransactionReceipt> getTransactionReceipt(StringtransactionHash);

  //extend(property: String, methods: IMethod[])

  Future<IBlock> getBlock(blockHashOrBlockNumber);

  Future<IBlockWithTransaction> getBlockWithTransaction(blockHashOrBlockNumber);

  Future<IJsonRpcResponse> sendRPCRequest(IJsonRpcRequestPayload request);

  String encodeParameters({
    List<dynamic> params = const [],
    List<dynamic> types = const [],
  });

  List<dynamic> decodeParameters({
    required String hexString,
    List<dynamic> types = const [],
  });

  String etheriumSha3(dynamic value);
}

extension BaseWeb3ClientGetRootHash on BaseWeb3Client {
  getRootHash(num startBlock, num endBlock) {
    return sendRPCRequest(
      IJsonRpcRequestPayload(
        jsonrpc: '2.0',
        method: 'eth_getRootHash',
        params: [startBlock, endBlock],
        id: DateTime.now().millisecondsSinceEpoch,
      ),
    ).then((payload) {
      return '${payload.result}';
    });
  }
} */