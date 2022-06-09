import 'package:matic_dart/abstracts/index.dart';
import 'package:matic_dart/interfaces/block.dart';
import 'package:matic_dart/interfaces/block_with_transaction.dart';
import 'package:matic_dart/interfaces/rpc_request_payload.dart';
import 'package:matic_dart/interfaces/rpc_response_payload.dart';
import 'package:matic_dart/interfaces/transaction_config.dart';
import 'package:matic_dart/interfaces/transaction_data.dart';
import 'package:matic_dart/interfaces/transaction_write_result.dart';
import 'package:matic_dart/interfaces/tx_receipt.dart';
import 'package:matic_dart/utils/logger.dart';

class BaseWeb3ClientImpl extends BaseWeb3Client {
  @override
  List decodeParameters({required String hexString, List types = const []}) {
    // TODO: implement decodeParameters
    throw UnimplementedError();
  }

  @override
  String encodeParameters({List params = const [], List types = const []}) {
    // TODO: implement encodeParameters
    throw UnimplementedError();
  }

  @override
  Future<num> estimateGas(ITransactionRequestConfig config) {
    // TODO: implement estimateGas
    throw UnimplementedError();
  }

  @override
  String etheriumSha3(value) {
    // TODO: implement etheriumSha3
    throw UnimplementedError();
  }

  @override
  Future<IBlock> getBlock(blockHashOrBlockNumber) {
    // TODO: implement getBlock
    throw UnimplementedError();
  }

  @override
  Future<IBlockWithTransaction> getBlockWithTransaction(blockHashOrBlockNumber) {
    // TODO: implement getBlockWithTransaction
    throw UnimplementedError();
  }

  @override
  Future<num> getChainId() {
    // TODO: implement getChainId
    throw UnimplementedError();
  }

  @override
  BaseContract getContract({required String address, required abi}) {
    // TODO: implement getContract
    throw UnimplementedError();
  }

  @override
  Future<String> getGasPrice() {
    // TODO: implement getGasPrice
    throw UnimplementedError();
  }

  @override
  Future<ITransactionData> getTransaction(String transactionHash) {
    // TODO: implement getTransaction
    throw UnimplementedError();
  }

  @override
  Future<num> getTransactionCount({required String address, required blockNumber}) {
    // TODO: implement getTransactionCount
    throw UnimplementedError();
  }

  @override
  Future<ITransactionReceipt> getTransactionReceipt(StringtransactionHash) {
    // TODO: implement getTransactionReceipt
    throw UnimplementedError();
  }

  @override
  Future<String> read(ITransactionRequestConfig config) {
    // TODO: implement read
    throw UnimplementedError();
  }

  @override
  Future<IJsonRpcResponse> sendRPCRequest(IJsonRpcRequestPayload request) {
    // TODO: implement sendRPCRequest
    throw UnimplementedError();
  }

  @override
  ITransactionWriteResult write(ITransactionRequestConfig config) {
    // TODO: implement write
    throw UnimplementedError();
  }
}


abstract class BaseWeb3Client /*  extends Web3Client */ {
  final Logger logger;

  const BaseWeb3Client({required this.logger});

  BaseContract getContract({
    required String address,
    required dynamic abi,
  });

  Future<String> read(ITransactionRequestConfig config);

  ITransactionWriteResult write(ITransactionRequestConfig config);

  Future<String> getGasPrice();

  Future<num> estimateGas(ITransactionRequestConfig config);

  Future<num> getChainId();

  Future<num> getTransactionCount({
    required String address,
    required dynamic blockNumber,
  });

  Future<ITransactionData> getTransaction(String transactionHash);

  Future<ITransactionReceipt> getTransactionReceipt(StringtransactionHash);

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
}
