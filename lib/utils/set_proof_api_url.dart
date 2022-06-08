
import 'package:matic_dart/services/index.dart';
import 'package:matic_dart/services/network_service.dart';

void setProofApi(String url) {
    var urlLength = url.length;
    if (url[urlLength - 1] != '/') {
        url += '/';
    }
    url += 'api/v1/';
    service.network = NetworkService(url);
}