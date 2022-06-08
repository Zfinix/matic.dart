abstract class ITransactionData {
  final String transactionHash;
  final num nonce;
  final String? blockHash;
  final num? blockNumber;
  final num? transactionIndex;
  final String from;
  final String? to;
  final String value;
  final String gasPrice;
  final num gas;
  final String input;

  const ITransactionData({
    this.to,
    this.blockHash,
    this.blockNumber,
    this.transactionIndex,
    required this.nonce,
    required this.from,
    required this.value,
    required this.gasPrice,
    required this.gas,
    required this.input,
    required this.transactionHash,
  });
}
