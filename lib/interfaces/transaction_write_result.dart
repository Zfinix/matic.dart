import 'package:web3dart/web3dart.dart';

abstract class ITransactionWriteResult {
  String get transactionHash;
  Future<TransactionReceipt?> getReceipt();
}
