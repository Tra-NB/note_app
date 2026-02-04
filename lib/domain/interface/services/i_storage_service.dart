
abstract class IStorageService {
  Future<String?> upload(dynamic file);
  Future<void> delete(String url);
}