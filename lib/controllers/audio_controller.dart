
import 'package:uas_project/models/audio_entity.dart';
import 'package:uas_project/models/audio_player_state.dart';
import 'package:uas_project/models/audio_repository.dart';

class AudioController {
  final AudioRepository repository;

  AudioController(this.repository);

  Stream<AudioPlayerState> get state => repository.state;

  void play(AudioEntity audio) => repository.play(audio);
  void pause() => repository.pause();
  void stop() => repository.stop();
}
