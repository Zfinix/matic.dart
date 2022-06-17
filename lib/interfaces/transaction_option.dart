import 'package:matic_dart/interfaces/transaction_config.dart';

abstract class ITransactionOption extends ITransactionRequestConfig {
  final bool returnTransaction;
  ITransactionOption({
    this.returnTransaction = false,
  });
}
