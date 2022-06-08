T? resolve<T>(Map<String, dynamic>? obj, dynamic path) {
  try {
    dynamic current = obj;
    Iterable<String> properties;

    if (path is Iterable) {
      properties = path.map((e) => '$e');
    } else {
      properties = '$path'.split('.');
    }
    properties.forEach((segment) {
      final maybeInt = int.tryParse(segment);

      if (maybeInt != null && current is List<dynamic>) {
        current = current[maybeInt];
      } else if (current is Map<String, dynamic>) {
        current = current[segment];
      }
    });

    return current as T?;
  } catch (error) {
    print(error);
    return null;
  }
}
