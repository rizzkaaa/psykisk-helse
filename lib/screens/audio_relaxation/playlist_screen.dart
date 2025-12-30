import 'package:flutter/material.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;
import 'package:provider/provider.dart';
import 'package:uas_project/controllers/auth_controller.dart';
import 'package:uas_project/screens/audio_relaxation/audio_list_screen.dart';

class AudioPlaylistScreen extends StatelessWidget {
  const AudioPlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final user = auth.userData;

    final playlists = [
      {
        'title': 'Deep Relax',
        'desc': 'Calm your mind & body',
        'icon': Icons.spa,
        'audios': deepRelaxAudios,
        'gradient': [Color(0xFF6B8E7B), Color(0xFF5A7863)],
      },
      {
        'title': 'Sleep Better',
        'desc': 'Gentle sounds for sleep',
        'icon': Icons.nights_stay,
        'audios': sleepAudios,
        'gradient': [Color(0xFF7B9B8B), Color(0xFF5A7863)],
      },
      {
        'title': 'Focus Mode',
        'desc': 'Stay present & productive',
        'icon': Icons.center_focus_strong,
        'audios': focusAudios,
        'gradient': [Color(0xFF8BAA9B), Color(0xFF6B8E7B)],
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFEBF4DD),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: inset.BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        inset.BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 2,
                          offset: Offset(1, 0),
                          inset: true,
                        ),
                        inset.BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 2,
                          offset: Offset(-1, 0),
                          inset: true,
                        ),
                      ],
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.reply,
                            color: Color(0xFF73a664),
                          ),
                          onPressed: () => Navigator.pop(context),
                          tooltip: "Back",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Title Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  user == null
                      ? const CircularProgressIndicator(
                          color: Color(0xFF5A7863),
                        )
                      : Text(
                          'Hello ${user.username},',
                          style: TextStyle(
                            fontSize: 16,
                            color: const Color(0xFF5A7863).withOpacity(0.7),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                  const SizedBox(height: 4),
                  Text(
                    'Continue\nRelaxing!',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF5A7863),
                      height: 1.2,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Playlists Label
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Your playlists',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF5A7863).withOpacity(0.8),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Playlists Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: playlists.length,
                  itemBuilder: (context, index) {
                    final p = playlists[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AudioListScreen(
                              title: p['title'] as String,
                              audios: p['audios'] as List<Map<String, String>>,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: p['gradient'] as List<Color>,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: (p['gradient'] as List<Color>)[0]
                                  .withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Decorative circles
                            Positioned(
                              top: -20,
                              right: -20,
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.1),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: -30,
                              left: -30,
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.08),
                                ),
                              ),
                            ),

                            // Content
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.25),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(
                                      p['icon'] as IconData,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    p['title'] as String,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    p['desc'] as String,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.85),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final deepRelaxAudios = [
  {'title': 'Forest Birds', 'asset': 'assets/audio/birds-forest.mp3'},
  {'title': 'Soft Rain', 'asset': 'assets/audio/ambient-forest-rain.mp3'},
];

final sleepAudios = [
  {'title': 'Night Crickets', 'asset': 'assets/audio/midnight-forest.mp3'},
  {'title': 'Ocean Waves', 'asset': 'assets/audio/ocean-meditation.mp3'},
];

final focusAudios = [
  {'title': 'Brown Noise', 'asset': 'assets/audio/healing-dreams.mp3'},
  {'title': 'Deep Focus', 'asset': 'assets/audio/healing-light.mp3'},
];
