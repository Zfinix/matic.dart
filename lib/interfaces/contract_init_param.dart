import 'package:web3dart/web3dart.dart';

class IContractInitParam {
  final EthereumAddress address;
  final String? bridgeType;
  final bool isParent;

  /// used to get the predicate
  final String name;

  const IContractInitParam({
    required this.address,
    required this.isParent,
    required this.name,
    this.bridgeType,
  });
}
