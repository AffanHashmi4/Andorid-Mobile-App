import 'package:flutter/material.dart';
import '../data/surah_data.dart';
import '../services/audio_player_service.dart';

class MushafScreen extends StatefulWidget {
  final Surah surah;
  const MushafScreen({super.key, required this.surah});

  @override
  State<MushafScreen> createState() => _MushafScreenState();
}

class _MushafScreenState extends State<MushafScreen> {
  late final ScrollController _controller;
  double _pageHeight = 600;
  int _currentPage = 1;

  static const _invertColors = ColorFilter.matrix(<double>[
    -1, 0, 0, 0, 255,
    0, -1, 0, 0, 255,
    0, 0, -1, 0, 255,
    0, 0, 0, 1, 0,
  ]);

  // One-time guess at which page playback is probably on right now, based
  // on how far through the audio we are. Not exact -- recitation pace
  // varies -- but a much better starting point than always page 1.
  int _estimateOpeningPage() {
    final position = AudioPlayerService.instance.player.position;
    final duration = AudioPlayerService.instance.player.duration;

    if (duration == null || duration.inMilliseconds <= 0) {
      return widget.surah.startPage;
    }

    final nextIndex = widget.surah.number; // index of the next surah in the list
    final endPage = nextIndex < surahs.length ? surahs[nextIndex].startPage : 605;
    final pageSpan = (endPage - widget.surah.startPage).clamp(1, 999);

    final progress =
        (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);
    final estimatedPage = widget.surah.startPage + (progress * pageSpan).floor();

    return estimatedPage.clamp(widget.surah.startPage, 604);
  }

  @override
  void initState() {
    super.initState();
    _currentPage = _estimateOpeningPage();
    _controller = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.jumpTo((_currentPage - 1) * _pageHeight);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _pageAsset(int page) =>
      'assets/mushaf/${page.toString().padLeft(3, '0')}.png';

  @override
  Widget build(BuildContext context) {
    _pageHeight = MediaQuery.of(context).size.height * 0.85;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: () =>
                        Navigator.of(context).popUntil((r) => r.isFirst),
                    icon: const Icon(Icons.chevron_left),
                    label: const Text('Back to Library'),
                  ),
                ],
              ),
            ),
            Text(
              widget.surah.nameEnglish,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.greenAccent,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: NotificationListener<ScrollUpdateNotification>(
                onNotification: (notification) {
                  final page = (_controller.offset / _pageHeight).round() + 1;
                  if (page != _currentPage && page >= 1 && page <= 604) {
                    setState(() => _currentPage = page);
                  }
                  return false;
                },
                child: ListView.builder(
                  controller: _controller,
                  itemCount: 604,
                  itemExtent: _pageHeight,
                  itemBuilder: (context, index) {
                    final page = index + 1;
                    return ColorFiltered(
                      colorFilter: _invertColors,
                      child: Image.asset(_pageAsset(page), fit: BoxFit.contain),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text('Page $_currentPage (estimated)',
                  style: const TextStyle(fontSize: 13, color: Colors.yellow)),
            ),
          ],
        ),
      ),
    );
  }
}