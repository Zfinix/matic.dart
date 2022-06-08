import 'package:matic_dart/abstracts/contract_method.dart';
import 'package:matic_dart/utils/logger.dart';

abstract class BaseContract {
  final String address;
  final Logger logger;

  const BaseContract({required this.address, required this.logger});

  BaseContractMethod method(String methodName, dynamic args);
}
