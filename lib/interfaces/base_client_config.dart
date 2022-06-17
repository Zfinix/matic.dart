import 'dart:convert';

class IBaseClientConfig {
  final String network;
  final String version;
  final bool log;
  final num? requestConcurrency;
  IBaseClient? parent;
  IBaseClient? child;

  IBaseClientConfig({
   required  this.network,
   required this.version,
    this.parent,
    this.child,
    this.log = false,
    this.requestConcurrency,
  });

  IBaseClientConfig copyWith({
    String? network,
    String? version,
    IBaseClient? parent,
    IBaseClient? child,
    bool? log,
    num? requestConcurrency,
  }) {
    return IBaseClientConfig(
      network: network ?? this.network,
      version: version ?? this.version,
      parent: parent ?? this.parent,
      child: child ?? this.child,
      log: log ?? this.log,
      requestConcurrency: requestConcurrency ?? this.requestConcurrency,
    );
  }
}

class IBaseClient {
  dynamic provider;
  IBaseClientDefaultConfig defaultConfig;
  IBaseClient({
    required this.provider,
    required this.defaultConfig,
  });

  IBaseClient copyWith({
    dynamic provider,
    IBaseClientDefaultConfig? defaultConfig,
  }) {
    return IBaseClient(
      provider: provider ?? this.provider,
      defaultConfig: defaultConfig ?? this.defaultConfig,
    );
  }
}

class IBaseClientDefaultConfig {
  final List<String> from;

  const IBaseClientDefaultConfig({this.from = const []});

  Map<String, dynamic> toMap() {
    return {
      'from': from,
    };
  }

  factory IBaseClientDefaultConfig.fromMap(Map<String, dynamic> map) {
    return IBaseClientDefaultConfig(
      from: List<String>.from(map['from']),
    );
  }

  String toJson() => json.encode(toMap());

  factory IBaseClientDefaultConfig.fromJson(String source) => IBaseClientDefaultConfig.fromMap(json.decode(source));
}
