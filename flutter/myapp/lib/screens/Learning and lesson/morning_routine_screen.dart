import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/screens/activity_screens/morning_routine_game.dart';

class MorningRoutineScreen extends StatefulWidget {
  final String title;
  final String imagePath;
  final String videoPath;

  const MorningRoutineScreen({
    super.key,
    required this.title,
    required this.imagePath,
    required this.videoPath,
  });

  @override
  State<MorningRoutineScreen> createState() => _MorningRoutineScreenState();
}

class _MorningRoutineScreenState extends State<MorningRoutineScreen> {
  late VideoPlayerController _controller;
  bool isStarted = false;
  bool isCompleted = false;
  bool hasWatchedBefore = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) => setState(() {}));

    _loadCompletionStatus();

    _controller.addListener(() {
      if (_controller.value.isInitialized &&
          _controller.value.position >= _controller.value.duration &&
          !_controller.value.isPlaying &&
          !isCompleted &&
          !hasWatchedBefore) {
        // ✅ extra condition
        setState(() {
          isCompleted = true;
        });
        _markVideoAsWatched();
      }
    });
  }

  Future<String> _getUserSpecificKey() async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? 'guest';
    return 'morning_routine_screen_watched_${widget.title}_$userId';
  }

  Future<void> _loadCompletionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _getUserSpecificKey();
    hasWatchedBefore = prefs.getBool(key) ?? false;
    setState(() {});
  }

  Future<void> _markVideoAsWatched() async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _getUserSpecificKey();
    await prefs.setBool(key, true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playVideo() {
    setState(() {
      isStarted = true;
      isCompleted = false;
    });
    _controller.seekTo(Duration.zero);
    _controller.play();
  }

  void _replayVideo() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder:
            (_) => MorningRoutineScreen(
              title: widget.title,
              imagePath: widget.imagePath,
              videoPath: widget.videoPath,
            ),
      ),
    );
  }

  void _seekForward() {
    final position = _controller.value.position + const Duration(seconds: 5);
    if (position < _controller.value.duration) {
      _controller.seekTo(position);
    }
  }

  void _seekBackward() {
    final position = _controller.value.position - const Duration(seconds: 5);
    _controller.seekTo(position > Duration.zero ? position : Duration.zero);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color.fromARGB(255, 161, 129, 216),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              isCompleted
                  ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "🎉 Great Job! You've completed the routine!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      IconButton(
                        icon: const Icon(
                          Icons.loop,
                          size: 50,
                          color: Colors.deepPurple,
                        ),
                        onPressed: _replayVideo,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => MorningRoutineGameScreen(
                                    title: "Morning Routine Game",
                                    skill: "Cognitive",
                                  ),
                            ),
                          );
                        },
                        child: const Text("Move to Games"),
                      ),
                    ],
                  )
                  : isStarted
                  ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _controller.value.isInitialized
                          ? AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                VideoPlayer(_controller),
                                IconButton(
                                  icon: const Icon(
                                    Icons.fullscreen,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => FullScreenVideo(
                                              playerController: _controller,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          )
                          : const CircularProgressIndicator(),
                      const SizedBox(height: 10),
                      VideoProgressIndicator(
                        _controller,
                        allowScrubbing: true,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.replay_5),
                            onPressed: _seekBackward,
                            iconSize: 36,
                            color: Colors.deepPurple,
                          ),
                          IconButton(
                            icon: Icon(
                              _controller.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                            ),
                            onPressed: () {
                              setState(() {
                                _controller.value.isPlaying
                                    ? _controller.pause()
                                    : _controller.play();
                              });
                            },
                            iconSize: 40,
                            color: Colors.deepPurple,
                          ),
                          IconButton(
                            icon: const Icon(Icons.forward_5),
                            onPressed: _seekForward,
                            iconSize: 36,
                            color: Colors.deepPurple,
                          ),
                        ],
                      ),
                    ],
                  )
                  : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(widget.imagePath, height: 200),
                      const SizedBox(height: 20),
                      if (hasWatchedBefore)
                        Column(
                          children: [
                            ElevatedButton.icon(
                              onPressed: _playVideo,
                              icon: const Icon(Icons.play_arrow),
                              label: const Text("Watch Again"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  161,
                                  129,
                                  216,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => MorningRoutineGameScreen(
                                          title: "Morning Routine Game",
                                          skill: "Cognitive",
                                        ),
                                  ),
                                );
                              },
                              child: const Text("Play Game"),
                            ),
                          ],
                        )
                      else
                        ElevatedButton.icon(
                          onPressed: _playVideo,
                          icon: const Icon(Icons.play_arrow),
                          label: const Text("Play Routine"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              161,
                              129,
                              216,
                            ),
                          ),
                        ),
                    ],
                  ),
        ),
      ),
    );
  }
}

class FullScreenVideo extends StatelessWidget {
  final VideoPlayerController playerController;

  const FullScreenVideo({super.key, required this.playerController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AspectRatio(
          aspectRatio: playerController.value.aspectRatio,
          child: VideoPlayer(playerController),
        ),
      ),
    );
  }
}
