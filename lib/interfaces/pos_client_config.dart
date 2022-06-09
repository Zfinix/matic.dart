import 'package:matic_dart/interfaces/base_client_config.dart';

class IPOSERC1155Address {
  final String? mintablePredicate;

  const IPOSERC1155Address({this.mintablePredicate});
}

class IPOSClientConfig extends IBaseClientConfig {
  final String? rootChainManager;
  final String? rootChain;
  final IPOSERC1155Address? erc1155;

  IPOSClientConfig({
    required this.rootChainManager,
    required this.rootChain,
    required this.erc1155,
    List<String>? network,
    List<String>? version,
    IBaseClient? parent,
    IBaseClient? child,
    bool? log,
    num? requestConcurrency,
  });
}
