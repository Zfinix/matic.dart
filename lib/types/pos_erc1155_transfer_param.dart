

import 'package:matic_dart/types/index.dart';

class POSERC1155TransferParam {
  final TYPE_AMOUNT tokenId;
  final TYPE_AMOUNT amount;
  final String userAddress;
  final String? data;

  const POSERC1155TransferParam({
    required this.tokenId,
    required this.amount,
    required this.userAddress,
    this.data,
  });
}
