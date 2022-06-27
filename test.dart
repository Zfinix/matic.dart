import 'dart:convert';
import 'dart:typed_data';

import 'package:matic_dart/index.dart';
import 'package:web3dart/src/utils/length_tracking_byte_sink.dart';
import 'package:web3dart/web3dart.dart';

void main(List<String> args) async {
  final client = MaticWeb3Client(
    cred: EthPrivateKey.fromHex('0x8a91E7Ec54E284390729225FcCbc86846c46DDA9'),
    //  url: 'https://mainnet.infura.io/v3/148f7fe493a7491591c234f338e601be',
    url:
        'https://polygon-mainnet.g.alchemy.com/v2/_NCDIJfbl2o5tCbgyKZt6O576fHykBuf',
  );

  final buffer = LengthTrackingByteSink();

  final baz = FixedBytes(32)
    ..encode(utf8.encode('0xdf3234') as Uint8List, buffer);

  print(baz.name);
}
