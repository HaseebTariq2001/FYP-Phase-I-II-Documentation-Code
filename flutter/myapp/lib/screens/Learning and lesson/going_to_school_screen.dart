// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:video_player/video_player.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:myapp/screens/activity_screens/going_to_school_game.dart';

// class GoingToSchoolScreen extends StatefulWidget {
//   final String title;
//   final String imagePath;
//   final String videoPath;

//   const GoingToSchoolScreen({
//     required this.title,
//     required this.imagePath,
//     required this.videoPath,
//   });

//   @override
//   State<GoingToSchoolScreen> createState() => _GoingToSchoolScreenState();
// }

// class _GoingToSchoolScreenState extends State<GoingToSchoolScreen> {
//   late VideoPlayerController _controller;
//   bool isStarted = false;
//   bool isCompleted = false;
//   bool hasWatchedBefore = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.asset(widget.videoPath)
//       ..initialize().then((_) => setState(() {}));

//     _loadCompletionStatus();

//     _controller.addListener(() {
//       if (_controller.value.isInitialized &&
//           _controller.value.position >= _controller.value.duration &&
//           !_controller.value.isPlaying &&
//           !isCompleted &&
//           !hasWatchedBefore) {
//         // ✅ extra condition
//         setState(() {
//           isCompleted = true;
//         });
//         _markVideoAsWatched();
//       }
//     });
//   }

//   Future<String> _getUserSpecificKey() async {
//     final user = FirebaseAuth.instance.currentUser;
//     final userId = user?.uid ?? 'guest';
//     return 'going_to_school_screen_watched_${widget.title}_$userId';
//   }

//   Future<void> _loadCompletionStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     final key = await _getUserSpecificKey();
//     hasWatchedBefore = prefs.getBool(key) ?? false;
//     setState(() {});
//   }

//   Future<void> _markVideoAsWatched() async {
//     final prefs = await SharedPreferences.getInstance();
//     final key = await _getUserSpecificKey();
//     await prefs.setBool(key, true);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _playVideo() {
//     setState(() {
//       isStarted = true;
//       isCompleted = false;
//     });
//     _controller.seekTo(Duration.zero);
//     _controller.play();
//   }

//   void _replayVideo() {
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(
//         builder:
//             (_) => GoingToSchoolScreen(
//               title: widget.title,
//               imagePath: widget.imagePath,
//               videoPath: widget.videoPath,
//             ),
//       ),
//     );
//   }

//   void _seekForward() {
//     final position = _controller.value.position + Duration(seconds: 5);
//     if (position < _controller.value.duration) {
//       _controller.seekTo(position);
//     }
//   }

//   void _seekBackward() {
//     final position = _controller.value.position - Duration(seconds: 5);
//     _controller.seekTo(position > Duration.zero ? position : Duration.zero);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         backgroundColor: const Color.fromARGB(255, 161, 129, 216),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child:
//               isCompleted
//                   ? Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         "🎉 Great Job! You've completed the routine!",
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 20),
//                       IconButton(
//                         icon: Icon(
//                           Icons.loop,
//                           size: 50,
//                           color: Colors.deepPurple,
//                         ),
//                         onPressed: _replayVideo,
//                       ),
//                       const SizedBox(height: 20),
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder:
//                                   (_) => GoingToSchoolRoutineGameScreen(
//                                     title: "Going to School Routine",
//                                     skill: "Cognitive",
//                                   ),
//                             ),
//                           );
//                         },
//                         child: Text("Move to Games"),
//                       ),
//                     ],
//                   )
//                   : isStarted
//                   ? Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       _controller.value.isInitialized
//                           ? AspectRatio(
//                             aspectRatio: _controller.value.aspectRatio,
//                             child: Stack(
//                               alignment: Alignment.topRight,
//                               children: [
//                                 VideoPlayer(_controller),
//                                 IconButton(
//                                   icon: Icon(
//                                     Icons.fullscreen,
//                                     color: Colors.black,
//                                   ),
//                                   onPressed: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder:
//                                             (_) => FullScreenVideo(
//                                               playerController: _controller,
//                                             ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ],
//                             ),
//                           )
//                           : CircularProgressIndicator(),
//                       const SizedBox(height: 10),
//                       VideoProgressIndicator(
//                         _controller,
//                         allowScrubbing: true,
//                         padding: EdgeInsets.symmetric(vertical: 8),
//                       ),
//                       const SizedBox(height: 10),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           IconButton(
//                             icon: Icon(Icons.replay_5),
//                             onPressed: _seekBackward,
//                             iconSize: 36,
//                             color: Colors.deepPurple,
//                           ),
//                           IconButton(
//                             icon: Icon(
//                               _controller.value.isPlaying
//                                   ? Icons.pause
//                                   : Icons.play_arrow,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 _controller.value.isPlaying
//                                     ? _controller.pause()
//                                     : _controller.play();
//                               });
//                             },
//                             iconSize: 40,
//                             color: Colors.deepPurple,
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.forward_5),
//                             onPressed: _seekForward,
//                             iconSize: 36,
//                             color: Colors.deepPurple,
//                           ),
//                         ],
//                       ),
//                     ],
//                   )
//                   : Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.asset(widget.imagePath, height: 200),
//                       const SizedBox(height: 20),
//                       if (hasWatchedBefore)
//                         Column(
//                           children: [
//                             ElevatedButton.icon(
//                               onPressed: _playVideo,
//                               icon: Icon(Icons.play_arrow),
//                               label: Text("Watch Again"),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: const Color.fromARGB(
//                                   255,
//                                   161,
//                                   129,
//                                   216,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 10),
//                             ElevatedButton(
//                               onPressed: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder:
//                                         (_) => GoingToSchoolRoutineGameScreen(
//                                           title: "Going to School Routine",
//                                           skill: "Cognitive",
//                                         ),
//                                   ),
//                                 );
//                               },
//                               child: Text("Play Game"),
//                             ),
//                           ],
//                         )
//                       else
//                         ElevatedButton.icon(
//                           onPressed: _playVideo,
//                           icon: Icon(Icons.play_arrow),
//                           label: Text("Play Routine"),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color.fromARGB(
//                               255,
//                               161,
//                               129,
//                               216,
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//         ),
//       ),
//     );
//   }
// }

// class FullScreenVideo extends StatelessWidget {
//   final VideoPlayerController playerController;

//   const FullScreenVideo({required this.playerController});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Center(
//         child: AspectRatio(
//           aspectRatio: playerController.value.aspectRatio,
//           child: VideoPlayer(playerController),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/screens/activity_screens/going_to_school_game.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart'; // Added for debugPrint

class GoingToSchoolScreen extends StatefulWidget {
  final String title;
  final String imagePath;
  final String videoPath;

  const GoingToSchoolScreen({
    required this.title,
    required this.imagePath,
    required this.videoPath,
  });

  @override
  State<GoingToSchoolScreen> createState() => _GoingToSchoolScreenState();
}

class _GoingToSchoolScreenState extends State<GoingToSchoolScreen> {
  late VideoPlayerController _controller;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool isStarted = false;
  bool isCompleted = false;
  bool hasWatchedBefore = false;
  String? _errorMessage; // Added: Track video initialization errors

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    // Modified: Initialize VideoPlayerController with error handling
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize()
          .then((_) {
            if (mounted) {
              setState(() {
                _errorMessage = null; // Clear any previous error
              });
              debugPrint('Video initialized successfully: ${widget.videoPath}');
            }
          })
          .catchError((error) {
            if (mounted) {
              setState(() {
                _errorMessage = 'Failed to initialize video: $error';
              });
              debugPrint('Video initialization error: $error');
            }
          });

    _loadCompletionStatus();

    _controller.addListener(() {
      if (_controller.value.isInitialized &&
          _controller.value.position >= _controller.value.duration &&
          !_controller.value.isPlaying &&
          !isCompleted &&
          !hasWatchedBefore) {
        setState(() {
          isCompleted = true;
        });
        _sendVideoCompleteNotification();
        _markVideoAsWatched();
        debugPrint('Video completed, notification sent');
      }
      // Added: Handle playback errors
      if (_controller.value.hasError && _errorMessage == null) {
        setState(() {
          _errorMessage =
              'Playback error: ${_controller.value.errorDescription}';
        });
        debugPrint('Playback error: ${_controller.value.errorDescription}');
      }
    });
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _sendVideoCompleteNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'video_channel_id',
          'Video Notifications',
          channelDescription: 'Notifies when a video routine is completed',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
        );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      'Time to Play! 🎮',
      'You’ve completed the routine! Try the game ⭐',
      platformChannelSpecifics,
      payload: 'video_complete',
    );
  }

  Future<String> _getUserSpecificKey() async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? 'guest';
    return 'going_to_school_screen_watched_${widget.title}_$userId';
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
    if (_controller.value.isInitialized) {
      setState(() {
        isStarted = true;
        isCompleted = false;
        _errorMessage = null; // Clear any error when playing
      });
      _controller.seekTo(Duration.zero);
      _controller.play();
      debugPrint('Playing video: ${widget.videoPath}');
    } else {
      setState(() {
        _errorMessage = 'Video not initialized. Please try again.';
      });
      debugPrint('Cannot play video: not initialized');
    }
  }

  void _replayVideo() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder:
            (_) => GoingToSchoolScreen(
              title: widget.title,
              imagePath: widget.imagePath,
              videoPath: widget.videoPath,
            ),
      ),
    );
  }

  void _seekForward() {
    if (_controller.value.isInitialized) {
      final position = _controller.value.position + Duration(seconds: 5);
      if (position < _controller.value.duration) {
        _controller.seekTo(position);
      }
    }
  }

  void _seekBackward() {
    if (_controller.value.isInitialized) {
      final position = _controller.value.position - Duration(seconds: 5);
      _controller.seekTo(position > Duration.zero ? position : Duration.zero);
    }
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
                      Text(
                        "🎉 Great Job! You've completed the routine!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      IconButton(
                        icon: Icon(
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
                                  (_) => GoingToSchoolRoutineGameScreen(
                                    title: "Going to School Routine",
                                    skill: "Cognitive",
                                  ),
                            ),
                          );
                        },
                        child: Text("Move to Games"),
                      ),
                    ],
                  )
                  : isStarted
                  ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Modified: Display error message or video player
                      if (_errorMessage != null)
                        Column(
                          children: [
                            Text(
                              _errorMessage!,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: _replayVideo,
                              child: Text("Retry"),
                            ),
                          ],
                        )
                      else if (_controller.value.isInitialized)
                        AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              VideoPlayer(_controller),
                              IconButton(
                                icon: Icon(
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
                      else
                        CircularProgressIndicator(),
                      if (_controller.value.isInitialized) ...[
                        const SizedBox(height: 10),
                        VideoProgressIndicator(
                          _controller,
                          allowScrubbing: true,
                          padding: EdgeInsets.symmetric(vertical: 8),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.replay_5),
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
                              icon: Icon(Icons.forward_5),
                              onPressed: _seekForward,
                              iconSize: 36,
                              color: Colors.deepPurple,
                            ),
                          ],
                        ),
                      ],
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
                              icon: Icon(Icons.play_arrow),
                              label: Text("Watch Again"),
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
                                        (_) => GoingToSchoolRoutineGameScreen(
                                          title: "Going to School Routine",
                                          skill: "Cognitive",
                                        ),
                                  ),
                                );
                              },
                              child: Text("Play Game"),
                            ),
                          ],
                        )
                      else
                        ElevatedButton.icon(
                          onPressed: _playVideo,
                          icon: Icon(Icons.play_arrow),
                          label: Text("Play Routine"),
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

  const FullScreenVideo({required this.playerController});

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
