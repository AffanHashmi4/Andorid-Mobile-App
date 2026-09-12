import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import '../data/surah_data.dart';
import 'storage_service.dart';

class AudioPlayerService extends ChangeNotifier {
  AudioPlayerService._internal() {
    player.currentIndexStream.listen((_) => notifyListeners());
    player.loopModeStream.listen((_) => notifyListeners());
    Timer.periodic(const Duration(seconds: 5), (_) => _persistPosition());
    _init();
  }
  static final AudioPlayerService instance = AudioPlayerService._internal();

  final AudioPlayer player = AudioPlayer();
  bool _initialized = false;

  Future<void> _init() async {
    await _initPlaylist();
    await _restoreLastPosition();
  }

  Future<void> _initPlaylist() async {
    final sources = surahs
        .map((surah) => AudioSource.asset(
              surah.audioAsset,
              tag: MediaItem(
                id: surah.id,
                title: surah.alternateName != null
                    ? 'Surah ${surah.number} - ${surah.nameEnglish} (${surah.alternateName})'
                    : 'Surah ${surah.number} - ${surah.nameEnglish}',
                artist: 'Sheikh Yasser Al-Dossari',
                album: 'S. M. Affan Hashmi',
              ),
            ))
        .toList();

    await player.setAudioSource(ConcatenatingAudioSource(children: sources));
    _initialized = true;
  }

  Future<void> _restoreLastPosition() async {
    final last = await StorageService.instance.getLastPosition();
    if (last == null) return;
    final surahNumber = last.$1;
    final positionMs = last.$2;
    if (surahNumber < 1 || surahNumber > surahs.length) return;
    await player.seek(Duration(milliseconds: positionMs), index: surahNumber - 1);
  }

  void _persistPosition() {
    final surah = currentSurah;
    if (surah != null) {
      StorageService.instance.saveLastPosition(surah.number, player.position.inMilliseconds);
    }
  }

  Surah? get currentSurah {
    final index = player.currentIndex;
    if (index == null || index < 0 || index >= surahs.length) return null;
    return surahs[index];
  }

  bool get isLooping => player.loopMode == LoopMode.one;

  Future<void> playSurah(Surah surah) async {
    if (!_initialized) await _initPlaylist();
    await player.seek(Duration.zero, index: surah.number - 1);
    await player.play();
  }

  Future<void> togglePlayPause() async {
    if (player.playing) {
      await player.pause();
    } else {
      await player.play();
    }
  }

  Future<void> toggleLoop() async {
    await player.setLoopMode(isLooping ? LoopMode.off : LoopMode.one);
  }

  Future<void> playNext() => player.seekToNext();
  Future<void> playPrevious() => player.seekToPrevious();
}