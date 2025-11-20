import 'package:citizencentric/data/network/error_handler.dart';

import '../request/request.dart';
import '../responses/response.dart';

const CACHE_HOME_KEY = "CACHE_HOME_KEY";
const CACHE_HOME_INTERVAL = 60 * 1000; // 1 min

abstract class LocalDataSource {
  Future<List<StafListResponse>> getHomeFromCache();
  Future<void> saveHomeToCache(List<StafListResponse> data);

  void clearCache();
  void removeFromCache(String key);
}

class LocalDataSourceImplementer implements LocalDataSource {
  Map<String, CachedItem> cacheMap = {};

  @override
  Future<List<StafListResponse>> getHomeFromCache() async {
    CachedItem? cachedItem = cacheMap[CACHE_HOME_KEY];

    if (cachedItem != null && cachedItem.isValid(CACHE_HOME_INTERVAL)) {
      return cachedItem.data;
    } else {
      throw ErrorHandler.handle(DataSource.CACHE_ERROR.getFailure());
    }
  }

  @override
  Future<void> saveHomeToCache(List<StafListResponse> data) async {
    cacheMap[CACHE_HOME_KEY] = CachedItem(data);
  }

  @override
  void clearCache() {
    cacheMap.clear();
  }

  @override
  void removeFromCache(String key) {
    cacheMap.remove(key);
  }
}

class CachedItem {
  dynamic data;
  int cacheTime = DateTime.now().millisecondsSinceEpoch;

  CachedItem(this.data);
}

extension CachedItemExtension on CachedItem {
  bool isValid(int expirationTimeInMillis) {
    int currentTime = DateTime.now().millisecondsSinceEpoch;

    // cacheTime is already in milliseconds
    int cacheTimeMillis = cacheTime;

    return (currentTime - cacheTimeMillis) < expirationTimeInMillis;
  }
}