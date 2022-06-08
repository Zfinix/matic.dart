import 'package:matic_dart/interfaces/block.dart';
import 'package:matic_dart/interfaces/transaction_data.dart';

class IBlockWithTransaction extends IBaseBlock {
  final List<ITransactionData> transactions;

  IBlockWithTransaction({
    this.transactions = const [],
    num? size,
    num? difficulty,
    num? totalDifficulty,
    List<String>? uncles,
    num? number,
    String? hash,
    String? parentHash,
    String? nonce,
    String? sha3Uncles,
    String? logsBloom,
    String? transactionsRoot,
    String? stateRoot,
    String? receiptsRoot,
    String? miner,
    String? extraData,
    num? gasLimit,
    num? gasUsed,
    dynamic timestamp,
    String? baseFeePerGas,
  }) : super(
          size: size ?? 0,
          difficulty: difficulty ?? 0,
          totalDifficulty: totalDifficulty ?? 0,
          uncles: [],
          number: number ?? 0,
          hash: hash ?? '',
          parentHash: parentHash ?? '',
          nonce: nonce ?? '',
          sha3Uncles: sha3Uncles ?? '',
          logsBloom: logsBloom ?? '',
          transactionsRoot: transactionsRoot ?? '',
          stateRoot: stateRoot ?? '',
          receiptsRoot: receiptsRoot ?? '',
          miner: miner ?? '',
          extraData: extraData ?? '',
          gasLimit: gasLimit ?? 0,
          gasUsed: gasUsed ?? 0,
          timestamp: timestamp,
          baseFeePerGas: baseFeePerGas,
        );
}
