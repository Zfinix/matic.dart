import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:matic_dart/index.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/json_rpc.dart';
import 'package:web3dart/web3dart.dart';

class MaticWeb3Client extends Web3Client {
  final String url;
  final Credentials cred;
  final Client? client;
  final Logger? kLogger;

  late RpcService _jsonRpc;

  Logger get logger => kLogger ?? Logger();

  MaticWeb3Client({
    required this.url,
    required this.cred,
    this.kLogger,
    this.client,
  }) : super(url, client ?? Client()) {
    _jsonRpc = JsonRPC(url, client ?? Client());
  }

  Future<String> read(ITransactionRequestConfig config) {
    return sendTransaction(cred, config.tx);
  }

  Future<TransactionWriteResult> write(ITransactionRequestConfig config) async {
    final txHash = await sendTransaction(cred, config.tx);
    return TransactionWriteResult(
      onTransactionReceipt: getTransactionReceipt(txHash),
      txHash: txHash,
    );
  }

  DeployedContract getContract({
    /// The lower-level ABI of this contract used to encode data to send in
    /// transactions when calling this contract.
    required ContractAbi abi,

    /// The Ethereum address at which this contract is reachable.
    required EthereumAddress address,
  }) =>
      DeployedContract(abi, address);

  Future<EtherAmount> getGasPrice() => getGasPrice();

  Future<BigInt> estimateGasUsingConfig(ITransactionRequestConfig config) {
    return estimateGas(
      sender: config.from,
      to: config.to,
      value: config.value,
      gasPrice: config.gasPrice,
      maxPriorityFeePerGas: config.maxPriorityFeePerGas,
      maxFeePerGas: config.maxFeePerGas,
      data: config.data,
    );
  }

  void ensureTransactionNotNull_(TransactionInformation? data) {
    if (data == null) {
      throw IError(
          type: ERROR_TYPE.invalidTransaction,
          message:
              'Could not retrieve transaction. Either it is invalid or might be in archive node.');
    }
  }

  Future<ITransactionData> getTransaction(String transactionHash) async {
    final tx = await getTransactionByHash(transactionHash);

    ensureTransactionNotNull_(tx);
    return ITransactionData.fromTransactionInformation(
        tx: tx, transactionHash: transactionHash);
  }

  Future<BlockInformation> getBlockByHash({
    String blockNumber = 'latest',
    bool isContainFullObj = true,
  }) {
    return makeRPCCall<Map<String, dynamic>>(
      'eth_getBlockByHash',
      [blockNumber, isContainFullObj],
    ).then((json) => BlockInformation.fromJson(json));
  }

  Future<BlockInformation> getBlockWithTransaction(blockHashOrBlockNumber) {
    return getBlockByHash(
      blockNumber: blockHashOrBlockNumber,
      isContainFullObj: true,
    );
  }

  Future<FeeHistoryModel> feeHistory({
    int blockCount = 1,
    String newestBlock = 'latest',
    List<int> rewardPercentiles = const [],
  }) {
    return makeRPCCall<Map<String, dynamic>>(
      'eth_feeHistory',
      [blockCount, newestBlock, rewardPercentiles],
    ).then((json) => FeeHistoryModel.fromMap(json));
  }

  Future<String> web3Sha3(String hash) => makeRPCCall<String>(
        'web3_sha3',
        [hash],
      );

  String encodeParameters(Iterable<FunctionParameter> params) {
    return params.map((p) => p.type.name).join(',');
  }

  /// Uses the known types of the function output to decode the value returned
  /// by a contract after making an call to it.
  ///
  /// The type of what this function returns is thus dependent from what it
  /// [outputs] are. For the conversions between dart types and solidity types,
  /// see the documentation for [encodeCall].
  List<dynamic> decodeParameters(
    String hexString,
    List<FunctionParameter> outputs,
  ) {
    final tuple = TupleType(outputs.map((p) => p.type).toList());
    final buffer = hexToBytes(hexString).buffer;

    final parsedData = tuple.decode(buffer, 0);
    return parsedData.data;
  }

  /// Compute the keccak256 cryptographic hash of a UTF-8 string, returned as a hex string.
  String etheriumSha3(
    Uint8List bytes, {
    bool include0x = true,
  }) {
    final messageHash = keccak256(bytes);
    return bytesToHex(messageHash, include0x: include0x);
  }

  String etheriumSha3FromString(String bytes) {
    return etheriumSha3(
      Uint8List.fromList(utf8.encode(bytes)),
    );
  }

  String etheriumSha3FromHex(String hexStr) => etheriumSha3(hexToBytes(hexStr));

  Future<T> makeRPCCall<T>(String function, [List<dynamic>? params]) async {
    try {
      final data = await _jsonRpc.call(function, params);
      // ignore: only_throw_errors
      if (data is Error || data is Exception) throw data;

      return data.result as T;
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      if (printErrors) print(e);

      rethrow;
    }
  }

  Future<String> getRootHash({
    required dynamic startBlock,
    required dynamic endBlock,
  }) {
    return makeRPCCall<String>(
      'eth_getRootHash',
      [startBlock, endBlock],
    );
  }
}
