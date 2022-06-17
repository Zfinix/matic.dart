class POSERC1155TransferParam {
  final BigInt tokenId;
  final BigInt amount;
  final String userAddress;
  final String? data;

  const POSERC1155TransferParam({
    required this.tokenId,
    required this.amount,
    required this.userAddress,
    this.data,
  });
}
