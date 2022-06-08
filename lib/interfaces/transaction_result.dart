import 'package:matic_dart/interfaces/transaction_config.dart';

abstract class ITransactionResult {
  Future<num> estimateGas(ITransactionRequestConfig? tx);
  String encodeABI();
}
