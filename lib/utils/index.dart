import 'package:matic_dart/abstracts/base_web3_client.dart';
import 'package:matic_dart/utils/converter.dart';
import 'package:matic_dart/utils/logger.dart';

export "abi_manager.dart";
export "base_token.dart";
export "bridge_client.dart";
export "converter.dart";
export "event_bus.dart";
export "http_request.dart";
export "logger.dart";
export "map_promise.dart";
export "merge.dart";
export "not_implemented.dart";
export "proof_util.dart";
export "resolve.dart";
export "set_proof_api_url.dart'.dart";
export "use.dart";
export "web3_side_chain_client.dart";

class Utils {
  static final converter = Converter();
  static final logger = Logger();
  static final web3Client = BaseWeb3Client();
  static final unstoppableDomains = Object();
}
