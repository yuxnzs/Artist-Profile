import 'package:hive/hive.dart';

class CacheManager {
  final String boxName;

  CacheManager(this.boxName);

  // Open Hive Box
  Future<Box> _openBox() async {
    return await Hive.openBox(boxName);
  }

  // Save cache data
  Future<void> saveCache<T>({
    required String key,
    required T data,
    required Duration cacheDuration,
  }) async {
    final box = await _openBox();
    // Now + cacheDuration to calculate expiry time
    final expiryTime = DateTime.now().add(cacheDuration).toIso8601String();

    final cacheData = <String, dynamic>{
      'expiry': expiryTime,
      'data': data,
    };

    // Save cache data
    await box.put(key, cacheData);
  }

  Future<T?> getCache<T>({
    required String key,
    bool isMap = false,
  }) async {
    final box = await _openBox();
    final cachedData = box.get(key);

    if (cachedData != null) {
      final expiry = DateTime.parse(cachedData['expiry']);
      if (DateTime.now().isBefore(expiry)) {
        final data = cachedData['data'];

        // If is Map, need a type conversion
        if (isMap) {
          // Cached data is returned as Map<dynamic, dynamic>, so need to convert it to Map<String, dynamic>
          return Map<String, dynamic>.from(data) as T;
        }

        return data as T;
      } else {
        await box.delete(key); // Delete expired cache
      }
    }
    return null; // If no cache or cache expired
  }
}
