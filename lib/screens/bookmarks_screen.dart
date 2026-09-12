import 'package:flutter/material.dart';
import '../data/surah_data.dart';
import '../services/storage_service.dart';
import 'player_screen.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  List<Surah> _bookmarkedSurahs = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final ids = await StorageService.instance.getBookmarks();
    setState(() {
      _bookmarkedSurahs = surahs.where((s) => ids.contains(s.number)).toList();
      _loading = false;
    });
  }

  Future<void> _removeBookmark(Surah surah) async {
    await StorageService.instance.toggleBookmark(surah.number);
    setState(() {
      _bookmarkedSurahs.removeWhere((s) => s.number == surah.number);
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text('Removed ${surah.nameEnglish} from bookmarks'),
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () async {
              await StorageService.instance.toggleBookmark(surah.number);
              _load();
            },
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.chevron_left),
                    label: const Text('Back to Library'),
                  ),
                ],
              ),
            ),
            const Text('Bookmarks',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
            const SizedBox(height: 16),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _bookmarkedSurahs.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32),
                          child: Center(
                            child: Text(
                              "No bookmarks yet. Tap the bookmark icon on a surah's player screen to add one.",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white54),
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _bookmarkedSurahs.length,
                          itemBuilder: (context, index) {
                            final surah = _bookmarkedSurahs[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF16301F),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        await Navigator.of(context).push(
                                          MaterialPageRoute(builder: (_) => PlayerScreen(surah: surah)),
                                        );
                                        _load();
                                      },
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 34,
                                            height: 34,
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.fromBorderSide(BorderSide(color: Colors.greenAccent)),
                                            ),
                                            child: Text('${surah.number}',
                                                style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                                          ),
                                          const SizedBox(width: 14),
                                          Expanded(
                                            child: Text(surah.nameEnglish,
                                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(surah.nameArabic, style: const TextStyle(fontSize: 18, color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => _removeBookmark(surah),
                                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                    tooltip: 'Remove bookmark',
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}