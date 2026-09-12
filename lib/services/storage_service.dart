import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  Future<void> saveLastPosition(int surahNumber, int positionMs) async {
    final prefs = await _prefs;
    await prefs.setInt('last_surah', surahNumber);
    await prefs.setInt('last_position_ms', positionMs);
  }

  Future<(int, int)?> getLastPosition() async {
    final prefs = await _prefs;
    final surah = prefs.getInt('last_surah');
    final position = prefs.getInt('last_position_ms');
    if (surah == null || position == null) return null;
    return (surah, position);
  }

  Future<List<int>> getBookmarks() async {
    final prefs = await _prefs;
    return prefs.getStringList('bookmarks')?.map(int.parse).toList() ?? [];
  }

  Future<void> toggleBookmark(int surahNumber) async {
    final prefs = await _prefs;
    final bookmarks = await getBookmarks();
    if (bookmarks.contains(surahNumber)) {
      bookmarks.remove(surahNumber);
    } else {
      bookmarks.add(surahNumber);
    }
    await prefs.setStringList('bookmarks', bookmarks.map((e) => e.toString()).toList());
  }

  Future<bool> isBookmarked(int surahNumber) async {
    final bookmarks = await getBookmarks();
    return bookmarks.contains(surahNumber);
  }
}