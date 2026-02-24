import 'package:citizencentric/data/network/error_handler.dart';

abstract class LocalDataSource {

  Future<List<T>> getListFromCache<T>(String key, int interval);
  Future<void> saveListToCache<T>(String key, List<T> data);

  Future<T> getObjectFromCache<T>(String key, int interval);
  Future<void> saveObjectToCache<T>(String key, T data);

  void clearCache();
  void removeFromCache(String key);
}

class LocalDataSourceImpl implements LocalDataSource {

  final Map<String, CachedItem> _cacheMap = {};

  // 🔹 EXISTING LIST CACHE
  @override
  Future<List<T>> getListFromCache<T>(String key, int interval) async {
    final cachedItem = _cacheMap[key];

    if (cachedItem != null && cachedItem.isValid(interval)) {
      return cachedItem.data as List<T>;
    } else {
      throw ErrorHandler.handle(DataSource.CACHE_ERROR.getFailure());
    }
  }

  @override
  Future<void> saveListToCache<T>(String key, List<T> data) async {
    _cacheMap[key] = CachedItem(data);
  }

  // 🔹 NEW SINGLE OBJECT CACHE (IMPORTANT)
  @override
  Future<T> getObjectFromCache<T>(String key, int interval) async {
    final cachedItem = _cacheMap[key];

    if (cachedItem != null && cachedItem.isValid(interval)) {
      return cachedItem.data as T;
    } else {
      throw ErrorHandler.handle(DataSource.CACHE_ERROR.getFailure());
    }
  }

  @override
  Future<void> saveObjectToCache<T>(String key, T data) async {
    _cacheMap[key] = CachedItem(data);
  }

  @override
  void clearCache() => _cacheMap.clear();

  @override
  void removeFromCache(String key) => _cacheMap.remove(key);
}

class CachedItem {
  final dynamic data;
  final int cacheTime = DateTime.now().millisecondsSinceEpoch;

  CachedItem(this.data);

  bool isValid(int expirationTimeInMillis) {
    return DateTime.now().millisecondsSinceEpoch - cacheTime <
        expirationTimeInMillis;
  }
}
