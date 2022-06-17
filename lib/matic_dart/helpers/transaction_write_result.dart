
import 'package:matic_dart/interfaces/transaction_write_result.dart';
import 'package:web3dart/web3dart.dart';

typedef VoidCallback = void Function();

class TransactionWriteResult implements ITransactionWriteResult {
  final Future<TransactionReceipt?> onTransactionReceipt;
  final String txHash;
  final VoidCallback? onTransactionReceiptError;

  TransactionWriteResult({
    required this.onTransactionReceipt,
    this.onTransactionReceiptError,
    required this.txHash,
  });

  @override
  Future<TransactionReceipt?> getReceipt() async {
    return await onTransactionReceipt;
  }

  @override
  String get transactionHash => txHash;
}
 