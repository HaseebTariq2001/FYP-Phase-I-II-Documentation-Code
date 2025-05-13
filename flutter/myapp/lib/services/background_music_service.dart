import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackgroundMusicService {
  static final BackgroundMusicService _instance = BackgroundMusicService._internal();
  factory BackgroundMusicService() => _instance;

  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  BackgroundMusicService._internal() {
    _audioPlayer = AudioPlayer();
  }

  Future<void> playBackgroundMusic() async {
    final prefs = await SharedPreferences.getInstance();
    bool isMusicOn = prefs.getBool('background_music_on') ?? false;   // ✅ correct key!

    if (isMusicOn && !_isPlaying) {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop); 
      await _audioPlayer.play(AssetSource('sounds/background_music.mp3'), volume: 0.5);
      _isPlaying = true;
    }
  }

  Future<void> stopBackgroundMusic() async {
    if (_isPlaying) {
      await _audioPlayer.stop();
      _isPlaying = false;
    }
  }

  Future<void> setVolume(double volume) async {
    if (_isPlaying) {
      await _audioPlayer.setVolume(volume);    // volume value between 0.0 and 1.0
    }
  }
  Future<void> checkAndStartMusic() async {
  final prefs = await SharedPreferences.getInstance();
  bool isMusicOn = prefs.getBool('background_music_on') ?? false;
  if (isMusicOn) {
    await playBackgroundMusic();
  }
}

  // ✅ Call this after login or in main.dart to auto start music if toggle was on
  // Future<void> checkAndPlayOnAppStart() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   bool isMusicOn = prefs.getBool('background_music_on') ?? false;
  //   if (isMusicOn) {
  //     await playBackgroundMusic();
  //   }
  // }

}
