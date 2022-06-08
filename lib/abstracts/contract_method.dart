import 'package:matic_dart/interfaces/transaction_config.dart';
import 'package:matic_dart/interfaces/transaction_write_result.dart';
import 'package:matic_dart/utils/logger.dart';

abstract class BaseContractMethod {
  final Logger logger;

  const BaseContractMethod({required this.logger});

  String get address;

  Future<T> read<T>(ITransactionRequestConfig? tx);

  ITransactionWriteResult write(ITransactionRequestConfig tx);

  Future<num> estimateGas(ITransactionRequestConfig tx);

  dynamic encodeABI();
}
