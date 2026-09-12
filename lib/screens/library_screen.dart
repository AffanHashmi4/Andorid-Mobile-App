import 'package:flutter/material.dart';
import '../data/surah_data.dart';
import '../services/audio_player_service.dart';
import 'player_screen.dart';
import 'bookmarks_screen.dart';
import 'about_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AudioPlayerService.instance,
      builder: (context, _) {
        final resumeSurah = AudioPlayerService.instance.currentSurah;
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const AboutScreen()),
                          );
                        },
                        icon: const Icon(Icons.info_outline, size: 16),
                        label: const Text('About'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.greenAccent,
                          side: const BorderSide(color: Colors.greenAccent),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const BookmarksScreen()),
                          );
                        },
                        icon: const Icon(Icons.bookmark_outline, size: 16),
                        label: const Text('Bookmarks'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.greenAccent,
                          side: const BorderSide(color: Colors.greenAccent),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Sheikh Yasser Al-Dossari Old Recitations',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 4),
                const Text('Full Offline MP3 Quran', style: TextStyle(color: Colors.white70, fontSize: 13)),
                if (resumeSurah != null) ...[
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => PlayerScreen(surah: resumeSurah)),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.greenAccent.withOpacity(0.4)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.play_circle_outline, color: Colors.greenAccent),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Continue listening: ${resumeSurah.nameEnglish}',
                                style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: surahs.length,
                    itemBuilder: (context, index) {
                      final surah = surahs[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF16301F),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => PlayerScreen(surah: surah)),
                            );
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(surah.nameEnglish,
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                    if (surah.alternateName != null)
                                      Text(
                                        surah.alternateName!,
                                        style: const TextStyle(fontSize: 11, color: Colors.white54, fontStyle: FontStyle.italic),
                                      ),
                                  ],
                                ),
                              ),
                              Text(surah.nameArabic, style: const TextStyle(fontSize: 18, color: Colors.white)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}