 class IJsonRpcRequestPayload {
  final num? id;
  final String method;
  final String jsonrpc;
  final List<dynamic> params;

  const IJsonRpcRequestPayload({
    required this.id,
    required this.method,
    required this.jsonrpc,
    this.params = const [],
  });
}
