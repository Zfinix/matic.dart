import 'package:matic_dart/interfaces/transaction_config.dart';

abstract class ITransactionOption extends ITransactionRequestConfig {
  final bool? returnTransaction;
  const ITransactionOption({
    this.returnTransaction,
  });
}
