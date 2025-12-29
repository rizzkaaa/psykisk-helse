import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:uas_project/models/audio_entity.dart';
import 'package:uas_project/models/audio_player_state.dart';
import 'package:uas_project/models/audio_repository.dart';

class AudioRepositoryImpl implements AudioRepository {
  final AudioPlayer _player = AudioPlayer();
  final _controller = StreamController<AudioPlayerState>.broadcast();

  AudioPlayerState _state = AudioPlayerState.initial();

  AudioRepositoryImpl() {
    _player.setLoopMode(LoopMode.one);
  }

  @override
  Stream<AudioPlayerState> get state => _controller.stream;

  @override
  Future<void> play(AudioEntity audio) async {
    if (_state.current?.id != audio.id) {
      await _player.stop();
      await _player.setAsset(audio.asset);
    }
    await _player.play();

    _emit(_state.copyWith(isPlaying: true, current: audio));
  }

  @override
  Future<void> pause() async {
    await _player.pause();
    _emit(_state.copyWith(isPlaying: false));
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    _emit(AudioPlayerState.initial());
  }

  void _emit(AudioPlayerState state) {
    _state = state;
    _controller.add(state);
  }

  void dispose() {
    _player.dispose();
    _controller.close();
  }
}
