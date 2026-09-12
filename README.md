# Sh Yasser Dossari Old Recitations — Full MP3 Offline Quran

A fully offline Android app built with Flutter that serves as a personal audio
library and Mushaf reader for Sheikh Yasser Al-Dossari's early recitations.

## Features

- **Offline audio library** — all 114 surahs, playable with no internet connection
- **Background playback** — continues with the screen off, with full lock-screen
  and notification media controls (play/pause/skip), powered by `just_audio` +
  `just_audio_background`
- **Mushaf viewer** — displays the authentic Madani Mushaf (604 pages), with a
  vertical continuous-scroll reading experience and colors inverted for a
  dark-themed UI
- **Bookmarks** — save surahs for quick access later, with swipe-to-undo removal
- **Resume playback** — remembers exactly where you left off between app launches
- **Repeat mode** — loop the current surah indefinitely
- **Surah metadata** — English names (with correct Arabic transliteration
  prefixes), alternate names, and Arabic script, mapped to their exact starting
  page in the standard 604-page Madani Mushaf

## Tech stack

- **Flutter / Dart**
- [`just_audio`](https://pub.dev/packages/just_audio) — audio playback engine
- [`just_audio_background`](https://pub.dev/packages/just_audio_background) —
  background/lock-screen media session support
- [`shared_preferences`](https://pub.dev/packages/shared_preferences) — local
  persistence for bookmarks and resume position

## Project structure

```
lib/
  data/
    surah_data.dart       # All 114 surahs: names, Arabic script, Mushaf page mapping
  services/
    audio_player_service.dart   # Shared playlist-based audio player + persistence
    storage_service.dart        # Bookmarks + resume-position storage
  screens/
    library_screen.dart   # Surah list, entry point
    player_screen.dart    # Playback controls, loop, bookmark toggle
    mushaf_screen.dart    # Scrollable Mushaf page viewer
    bookmarks_screen.dart # Saved surahs
    about_screen.dart     # Credits
```

## Note on assets

The compressed audio files and Mushaf page images used by this app are not
included in this repository, since the recitation audio is copyrighted
third-party content the author does not hold distribution rights to. The code
here reflects the app's full architecture and logic; the `assets/audio/` and
`assets/mushaf/` folders are excluded via `.gitignore`.

## Author

Syed Muhammad Affan Hashmi
