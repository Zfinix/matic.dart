import 'dart:typed_data';

import 'package:matic_dart/interfaces/transaction_config.dart';
import 'package:web3dart/web3dart.dart';

class ITransactionOption extends ITransactionRequestConfig {
  final bool returnTransaction;

  const ITransactionOption({
    this.returnTransaction = false,
  });

  static const empty = ITransactionOption(returnTransaction: false);

  @override
  ITransactionOption copyWith({
    bool? returnTransaction,
    BigInt? gasLimit,
    BigInt? chainId,
    String? chain,
    String? hardfork,
    String? type,
    EthereumAddress? from,
    EthereumAddress? to,
    int? maxGas,
    EtherAmount? gasPrice,
    EtherAmount? value,
    Uint8List? data,
    int? nonce,
    EtherAmount? maxPriorityFeePerGas,
    EtherAmount? maxFeePerGas,
  }) {
    return ITransactionOption(
      returnTransaction: returnTransaction ?? this.returnTransaction,
    );
  }
}
