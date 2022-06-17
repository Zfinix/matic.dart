import 'dart:typed_data';

import 'package:matic_dart/interfaces/transaction_config.dart';
import 'package:matic_dart/interfaces/transaction_write_result.dart';
import 'package:matic_dart/utils/logger.dart';
import 'package:web3dart/web3dart.dart';

abstract class BaseContractMethod {
  final Logger logger;

  const BaseContractMethod({required this.logger});

  EthereumAddress get address;

  Future<T> read<T>([ITransactionRequestConfig? tx]);

  ITransactionWriteResult write(ITransactionRequestConfig tx);

  Future<BigInt> estimateGas(ITransactionRequestConfig tx);

  Uint8List encodeABI();
}
