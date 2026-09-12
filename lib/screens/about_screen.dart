import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const Text(
                      'Sheikh\nYasser Al-Dossari\nOld Recitations',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    const Icon(Icons.menu_book, size: 90),
                    const SizedBox(height: 24),
                    const Text(
                      "This app is produced to provide users with an offline directory of "
                      "the entire Holy Quran's recitations in the youthful voice of an "
                      "Imam-e-Ka'aba, Sheikh Yasser bin Rashid bin Hussein Al-Wadaani "
                      "Al-Dossari.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, height: 1.6, color: Colors.white70),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      "These recordings are specifically from the year 1425 AH (and around) "
                      "when Sheikh was an Imam of Masjid Ad-Dakheel in Riyadh before being "
                      "appointed as an Imam (and Khateeb) of Masjid Al-Haram in Makkah.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, height: 1.6, color: Colors.white70),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      "All these recordings have been sourced from YouTube from various "
                      "channels who had uploaded the recordings for the sake of Allah.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, height: 1.6, color: Colors.white70),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      "(Recordings of some surahs in this style of Sheikh's recitation were "
                      "not available on YouTube, so the audios have been replaced with his "
                      "other beautiful recitations of those surahs.)",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: Colors.white54,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'May Allah reward those YouTubers; may Allah preserve our Sheikh.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'I faithfully dedicate this application to:\n'
                      'Hazrat Maulana Mufti Muhammad Ismail Rafiq Sahab',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Divider(color: Colors.white24),
                    const SizedBox(height: 16),
                    const Text(
                      'To report any issues with the application,\nplease contact the developer at:',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Colors.white54),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'professorchillen@gmail.com',
                      style: TextStyle(fontSize: 13, color: Colors.greenAccent),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Application designed & developed by:',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Colors.white54),
                    ),
                    const Text(
                      'Syed Muhammad Affan Hashmi',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}