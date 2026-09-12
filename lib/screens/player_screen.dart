import 'package:flutter/material.dart';
import '../data/surah_data.dart';
import '../services/audio_player_service.dart';
import '../services/storage_service.dart';
import 'mushaf_screen.dart';

class PlayerScreen extends StatefulWidget {
  final Surah surah;
  const PlayerScreen({super.key, required this.surah});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final _audio = AudioPlayerService.instance;

  @override
  void initState() {
    super.initState();
    if (_audio.currentSurah?.number != widget.surah.number) {
      _audio.playSurah(widget.surah);
    }
  }

  String _formatDuration(Duration d, bool showHours) {
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    if (showHours) {
      final hours = d.inHours.toString().padLeft(2, '0');
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _audio,
      builder: (context, _) {
        final surah = _audio.currentSurah ?? widget.surah;
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () =>
                            Navigator.of(context).popUntil((r) => r.isFirst),
                        icon: const Icon(Icons.chevron_left),
                        label: const Text('Back to Library'),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: _audio.toggleLoop,
                            tooltip: 'Repeat this surah',
                            icon: Icon(
                              Icons.repeat_one,
                              color: _audio.isLooping ? Colors.greenAccent : Colors.white54,
                            ),
                          ),
                          FutureBuilder<bool>(
                            future: StorageService.instance.isBookmarked(surah.number),
                            builder: (context, snapshot) {
                              final bookmarked = snapshot.data ?? false;
                              return IconButton(
                                tooltip: 'Bookmark this surah',
                                onPressed: () async {
                                  await StorageService.instance.toggleBookmark(surah.number);
                                  setState(() {});
                                },
                                icon: Icon(
                                  bookmarked ? Icons.bookmark : Icons.bookmark_border,
                                  color: Colors.greenAccent,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Text(
                  'Sheikh\nYasser Al-Dossari\nOld Recitations',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                const Icon(Icons.menu_book, size: 100),
                const Spacer(),
                Text(
                  surah.nameEnglish,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent,
                  ),
                ),
                if (surah.alternateName != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    'also known as ${surah.alternateName}',
                    style: const TextStyle(
                        fontSize: 13, color: Colors.white60, fontStyle: FontStyle.italic),
                  ),
                ],
                const SizedBox(height: 4),
                Text('Surah ${surah.number}',
                    style: const TextStyle(fontSize: 16, color: Colors.yellow)),
                const SizedBox(height: 20),
                StreamBuilder<Duration>(
                  stream: _audio.player.positionStream,
                  builder: (context, snapshot) {
                    final position = snapshot.data ?? Duration.zero;
                    final duration = _audio.player.duration ?? Duration.zero;
                    final showHours = duration.inHours > 0;
                    final maxMs = duration.inMilliseconds > 0
                        ? duration.inMilliseconds.toDouble()
                        : 1.0;
                    final valueMs = position.inMilliseconds
                        .clamp(0, maxMs.toInt())
                        .toDouble();
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 3,
                              thumbShape:
                                  const RoundSliderThumbShape(enabledThumbRadius: 6),
                            ),
                            child: Slider(
                              value: valueMs,
                              max: maxMs,
                              activeColor: Colors.greenAccent,
                              inactiveColor: Colors.white24,
                              onChanged: (v) => _audio.player
                                  .seek(Duration(milliseconds: v.toInt())),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_formatDuration(position, showHours),
                                  style: const TextStyle(fontSize: 12)),
                              Text(_formatDuration(duration, showHours),
                                  style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _controlButton(
                      icon: Icons.skip_previous,
                      label: 'Previous Surah',
                      onTap: _audio.playPrevious,
                    ),
                    const SizedBox(width: 24),
                    StreamBuilder<bool>(
                      stream: _audio.player.playingStream,
                      builder: (context, snapshot) {
                        final playing = snapshot.data ?? false;
                        return GestureDetector(
                          onTap: _audio.togglePlayPause,
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.greenAccent,
                            ),
                            child: Icon(
                              playing ? Icons.pause : Icons.play_arrow,
                              size: 34,
                              color: Colors.black,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 24),
                    _controlButton(
                      icon: Icons.skip_next,
                      label: 'Next Surah',
                      onTap: _audio.playNext,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => MushafScreen(surah: surah)),
                    );
                  },
                  icon: const Icon(Icons.menu_book_outlined),
                  label: const Text('View Mushaf Page'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _controlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        IconButton(
            onPressed: onTap, icon: Icon(icon, color: Colors.greenAccent, size: 32)),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}