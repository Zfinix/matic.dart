abstract class IJsonRpcResponse {
  final String jsonrpc;
  final num id;
  final Object? result;
  final String? error;

  IJsonRpcResponse({
    required this.jsonrpc,
    required this.id,
    this.result,
    this.error,
  });
}
