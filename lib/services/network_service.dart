import 'package:dartx/dartx.dart';
import 'package:matic_dart/interfaces/index.dart';
import 'package:matic_dart/utils/http_request.dart';

class NetworkService {
  final String baseUrl;
  const NetworkService(this.baseUrl);

  HttpRequest get httpRequest => HttpRequest(baseUrl);

  String createUrl(String network, String url) {
    return '${network == 'mainnet' ? 'matic' : 'mumbai'}${url}';
  }

  Future<dynamic> getBlockIncluded({
    required String network,
    required BigInt blockNumber,
  }) async {
    /* 
    {
            start: string;
            end: string;
            headerBlockNumber: BaseBigNumber;
        } */

    final url = createUrl(network, '/block-included/${blockNumber}');
    return httpRequest.get(url).then((result) {
      final res = result.fold((l) => {}, (r) => r.data);
      final headerBlockNumber = res['headerBlockNumber'] as String;
      final decimalHeaderBlockNumber = headerBlockNumber.slice(0, 2) == '0x'
          ? BigInt.parse(headerBlockNumber, radix: 16)
          : BigInt.parse(headerBlockNumber);
      res['headerBlockNumber'] = decimalHeaderBlockNumber;
      return res;
    });
  }

  Future getProof(
      {required String network, required IRootBlockInfo root}) async {
    final url = createUrl(
      network,
      '/fast-merkle-proof?start=${root.start}&end=${root.end}&number=${root.blockNumber}',
    );
    return httpRequest.get(url).then((result) {
      final res = result.fold((l) => {}, (r) => r.data);
      return res.data['proof'];
    });
  }
}
