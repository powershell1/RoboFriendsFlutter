mixin HashableObject {
  String get hash;

  @override
  bool operator ==(Object other) {
    if (other is HashableObject) {
      return hash == other.hash;
    }
    return false;
  }

  @override
  int get hashCode => hash.hashCode;
}