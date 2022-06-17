import 'package:matic_dart/pos/root_chain_manager.dart';

class IPOSContracts {
  final RootChainManager rootChainManager;
  final ExitUtil exitUtil;

  const IPOSContracts({
    required this.rootChainManager,
    required this.exitUtil,
  });
}
