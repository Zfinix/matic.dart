import 'package:matic_dart/interfaces/transaction_option.dart';

class IApproveTransactionOption extends ITransactionOption {
  /// address of spender
  ///
  /// **spender** - third-party user or a smart contract which can transfer your token on your behalf.
  ///
  final String spenderAddress;

  const IApproveTransactionOption({
    required this.spenderAddress,
  });

  static const empty = IApproveTransactionOption(spenderAddress: '');
}
