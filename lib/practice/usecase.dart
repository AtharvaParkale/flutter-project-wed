abstract class UseCase<K, V> {
  Future<K> call(V params);
}

class NoParams {}
