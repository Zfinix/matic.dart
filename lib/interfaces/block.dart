abstract class IBaseBlock {
  final num size;
  final num difficulty;
  final num totalDifficulty;
  final List<String> uncles;
  final num number;
  final String hash;
  final String parentHash;
  final String nonce;
  final String sha3Uncles;
  final String logsBloom;
  final String transactionsRoot;
  final String stateRoot;
  final String receiptsRoot;
  final String miner;
  final String extraData;
  final num gasLimit;
  final num gasUsed;
  final dynamic timestamp;
  final String? baseFeePerGas;

  const IBaseBlock({
    required this.size,
    required this.difficulty,
    required this.totalDifficulty,
    required this.uncles,
    required this.number,
    required this.hash,
    required this.parentHash,
    required this.nonce,
    required this.sha3Uncles,
    required this.logsBloom,
    required this.transactionsRoot,
    required this.stateRoot,
    required this.receiptsRoot,
    required this.miner,
    required this.extraData,
    required this.gasLimit,
    required this.gasUsed,
    required this.timestamp,
    required this.baseFeePerGas,
  });
}

class IBlock extends IBaseBlock {
  final List<String> transactions;

  IBlock({
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
