import 'dart:convert';

import 'package:web3dart/crypto.dart';

class Converter {
  static String stringToHex(String input) => bytesToHex(utf8.encode(input));
  static String bigIntToHex(BigInt input) => bytesToHex(intToBytes(input));
}
