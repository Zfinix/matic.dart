import 'package:matic_dart/abstracts/contract_method.dart';
import 'package:matic_dart/utils/logger.dart';
import 'package:web3dart/web3dart.dart';

abstract class BaseContract {
  final EthereumAddress address;
  final Logger logger;

  const BaseContract({required this.address, required this.logger});

  BaseContractMethod method(String methodName, List args);
}
