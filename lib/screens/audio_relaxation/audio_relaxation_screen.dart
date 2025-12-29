import 'dart:math';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioRelaxationScreen extends StatefulWidget {
  final List<Map<String, String>> playlist;
  final int startIndex;

  const AudioRelaxationScreen({
    super.key,
    required this.playlist,
    required this.startIndex,
  });

  @override
  State<AudioRelaxationScreen> createState() => _AudioRelaxationScreenState();
}

class _AudioRelaxationScreenState extends State<AudioRelaxationScreen>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _player = AudioPlayer();

  late int _currentIndex;
  bool _shuffle = false;
  LoopMode _loopMode = LoopMode.off;

  late AnimationController _playAnim;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.startIndex;

    _playAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      lowerBound: 0.9,
      upperBound: 1.1,
    );

    _load(_currentIndex);
  }

  Future<void> _load(int index) async {
    await _player.setAsset(widget.playlist[index]['asset']!);
    _player.play();
    _playAnim.forward();
    setState(() => _currentIndex = index);
  }

  void _togglePlay() {
    if (_player.playing) {
      _player.pause();
      _playAnim.reverse();
    } else {
      _player.play();
      _playAnim.forward();
    }
    setState(() {});
  }

  void _next() {
    if (_shuffle) {
      _load(Random().nextInt(widget.playlist.length));
    } else if (_currentIndex < widget.playlist.length - 1) {
      _load(_currentIndex + 1);
    }
  }

  void _prev() {
    if (_currentIndex > 0) {
      _load(_currentIndex - 1);
    }
  }

  @override
  void dispose() {
    _player.dispose();
    _playAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final audio = widget.playlist[_currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFEBF4DD),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primary.withOpacity(0.3),
              const Color(0xFFEBF4DD),
              const Color(0xFFEBF4DD),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Custom App Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: primary.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: primary,
                            size: 18,
                          ),
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: primary.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.more_vert,
                          color: primary,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Artwork with Decorative Pattern
                Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        primary.withOpacity(0.8),
                        primary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(200),
                    boxShadow: [
                      BoxShadow(
                        color: primary.withOpacity(0.4),
                        blurRadius: 40,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Decorative flower pattern
                      ...List.generate(8, (index) {
                        final angle = (index * pi / 4);
                        return Transform.rotate(
                          angle: angle,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        );
                      }),
                      
                      // Center Icon
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.self_improvement,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // White Card Section
                Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.45,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(40),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        // Progress Slider
                        StreamBuilder<Duration>(
                          stream: _player.positionStream,
                          builder: (context, snapshot) {
                            final position = snapshot.data ?? Duration.zero;
                            final duration = _player.duration ?? Duration.zero;

                            return Column(
                              children: [
                                SliderTheme(
                                  data: SliderThemeData(
                                    trackHeight: 4,
                                    thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 8,
                                    ),
                                    overlayShape: const RoundSliderOverlayShape(
                                      overlayRadius: 16,
                                    ),
                                    activeTrackColor: primary,
                                    inactiveTrackColor: primary.withOpacity(0.15),
                                    thumbColor: primary,
                                    overlayColor: primary.withOpacity(0.2),
                                  ),
                                  child: Slider(
                                    value: position.inSeconds.toDouble(),
                                    max: duration.inSeconds == 0
                                        ? 1
                                        : duration.inSeconds.toDouble(),
                                    onChanged: (value) {
                                      _player.seek(
                                        Duration(seconds: value.toInt()),
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      _time(position),
                                      _time(duration),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: 32),

                        // Title and Subtitle
                        Text(
                          audio['title']!,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: primary,
                            letterSpacing: -0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'By: Dr. P Golden',
                          style: TextStyle(
                            fontSize: 14,
                            color: primary.withOpacity(0.6),
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Control Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _controlButton(
                              icon: Icons.shuffle,
                              active: _shuffle,
                              onPressed: () =>
                                  setState(() => _shuffle = !_shuffle),
                              primary: primary,
                            ),
                            
                            const SizedBox(width: 20),
                            
                            _controlButton(
                              icon: Icons.skip_previous_rounded,
                              active: true,
                              onPressed: _prev,
                              primary: primary,
                              size: 32,
                            ),
                            
                            const SizedBox(width: 20),
                            
                            // Play/Pause Button
                            ScaleTransition(
                              scale: _playAnim,
                              child: Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      primary.withOpacity(0.9),
                                      primary,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: primary.withOpacity(0.4),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    _player.playing
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded,
                                    size: 36,
                                    color: Colors.white,
                                  ),
                                  onPressed: _togglePlay,
                                ),
                              ),
                            ),
                            
                            const SizedBox(width: 20),
                            
                            _controlButton(
                              icon: Icons.skip_next_rounded,
                              active: true,
                              onPressed: _next,
                              primary: primary,
                              size: 32,
                            ),
                            
                            const SizedBox(width: 20),
                            
                            _controlButton(
                              icon: _loopMode == LoopMode.one
                                  ? Icons.repeat_one_rounded
                                  : Icons.repeat_rounded,
                              active: _loopMode != LoopMode.off,
                              onPressed: () {
                                setState(() {
                                  _loopMode = _loopMode == LoopMode.off
                                      ? LoopMode.one
                                      : LoopMode.off;
                                });
                                _player.setLoopMode(_loopMode);
                              },
                              primary: primary,
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Bottom Navigation
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.home_rounded, color: primary, size: 26),
                              Icon(Icons.favorite_border, color: primary.withOpacity(0.4), size: 26),
                              Icon(Icons.notifications_outlined, color: primary.withOpacity(0.4), size: 26),
                              Icon(Icons.person_outline, color: primary.withOpacity(0.4), size: 26),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _controlButton({
    required IconData icon,
    required bool active,
    required VoidCallback onPressed,
    required Color primary,
    double size = 24,
  }) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: active ? primary.withOpacity(0.15) : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: active ? primary : primary.withOpacity(0.4),
          size: size,
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget _time(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return Text(
      '$m:$s',
      style: TextStyle(
        fontSize: 13,
        color: Theme.of(context).primaryColor.withOpacity(0.6),
        fontWeight: FontWeight.w500,
      ),
    );
  }
}