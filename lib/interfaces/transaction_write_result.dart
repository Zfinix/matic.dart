import 'package:matic_dart/interfaces/tx_receipt.dart';

abstract class ITransactionWriteResult {
  Future<String> getTransactionHash();
  Future<ITransactionReceipt> getReceipt();
}
