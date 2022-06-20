import 'package:matic_dart/utils/http_request.dart';

class ABIService {
  final String baseUrl;
  const ABIService(this.baseUrl);

  HttpRequest get httpRequest => HttpRequest(baseUrl);

  Future<Map<String, dynamic>> getABI({
    required String network,
    required String version,
    required String bridgeType,
    required String contractName,
  }) async {
    final url =
        '$network/$version/artifacts/$bridgeType/$contractName.json';

    final result = await httpRequest.get(url);
    return result.fold((l) => {}, (r) => r.data['abi']);
  }

  Future<dynamic> getAddress<T>({
    required String network,
    required String version,
  }) async {
    final url = '$network/$version/index.json';

    final result = await httpRequest.get(url);
    return result.fold((l) => null, (r) => r.data);
  }
}
