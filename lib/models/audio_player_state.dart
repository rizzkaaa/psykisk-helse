
import 'package:uas_project/models/audio_entity.dart';

class AudioPlayerState {
  final bool isPlaying;
  final AudioEntity? current;

  const AudioPlayerState({
    required this.isPlaying,
    required this.current,
  });

  factory AudioPlayerState.initial() =>
      const AudioPlayerState(isPlaying: false, current: null);

  AudioPlayerState copyWith({
    bool? isPlaying,
    AudioEntity? current,
  }) {
    return AudioPlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      current: current ?? this.current,
    );
  }
}
