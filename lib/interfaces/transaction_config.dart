abstract class ITransactionRequestConfig {
  final String? from;
  final String? to;
  final BigInt? value;
  final num? gasLimit;
  final BigInt? gasPrice;
  final String? data;
  final num? nonce;
  final num? chainId;
  final String? chain;
  final String? hardfork;
  final num? maxFeePerGas;
  final num? maxPriorityFeePerGas;
  final num? type;

  const ITransactionRequestConfig({
    this.from,
    this.to,
    this.value,
    this.gasLimit,
    this.gasPrice,
    this.data,
    this.nonce,
    this.chainId,
    this.chain,
    this.hardfork,
    this.maxFeePerGas,
    this.maxPriorityFeePerGas,
    this.type,
  });
}
