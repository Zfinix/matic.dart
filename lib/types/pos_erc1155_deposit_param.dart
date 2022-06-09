import 'package:matic_dart/types/index.dart';

class POSERC1155DepositParam {
  final TYPE_AMOUNT tokenId;
  final TYPE_AMOUNT amount;
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
  final List<TYPE_AMOUNT> tokenIds;
  final List<TYPE_AMOUNT> amounts;
  final String userAddress;
  final String? data;

  const POSERC1155DepositBatchParam({
    required this.tokenIds,
    required this.amounts,
    required this.userAddress,
    this.data,
  });
}
