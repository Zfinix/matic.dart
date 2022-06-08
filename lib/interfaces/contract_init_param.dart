abstract class IContractInitParam {
  final String address;
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
