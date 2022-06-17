class POSERC1155DepositParam {
  final BigInt tokenId;
  final BigInt amount;
  final String userAddress;
  final String? data;

  const POSERC1155DepositParam({
    required this.tokenId,
    required this.amount,
    required this.userAddress,
    this.data,
  });
}

class POSERC1155DepositBatchParam {
  final List<BigInt> tokenIds;
  final List<BigInt> amounts;
  final String userAddress;
  final String? data;

  const POSERC1155DepositBatchParam({
    required this.tokenIds,
    required this.amounts,
    required this.userAddress,
    this.data,
  });
}
