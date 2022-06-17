import 'package:matic_dart/interfaces/transaction_option.dart';

abstract class IAllowanceTransactionOption extends ITransactionOption {
  /// address of spender
  ///
  /// **spender** - third-party user or a smart contract which can transfer your token on your behalf.
  ///
  ///
  final String spenderAddress;

   IAllowanceTransactionOption({
    required this.spenderAddress,
  });
}
