
import 'package:uas_project/models/audio_entity.dart';
import 'package:uas_project/models/audio_player_state.dart';

abstract class AudioRepository {
  Stream<AudioPlayerState> get state;

  Future<void> play(AudioEntity audio);
  Future<void> pause();
  Future<void> stop();
}
