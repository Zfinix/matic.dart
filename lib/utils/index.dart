import 'package:matic_dart/abstracts/base_web3_client.dart';
import 'package:matic_dart/matic_dart/web3/web3_client.dart';
import 'package:matic_dart/utils/converter.dart';
import 'package:matic_dart/utils/logger.dart';

export "abi_manager.dart";
export "base_token.dart";
export "converter.dart";
export "event_bus.dart";
export "http_request.dart";
export "logger.dart";
export "resolve.dart";
export "web3_side_chain_client.dart";

class Utils {
  static Converter? converter;
  static Logger? logger;
  static Object? unstoppableDomains;
  static MaticWeb3Client? web3Client;

  const Utils();
}
