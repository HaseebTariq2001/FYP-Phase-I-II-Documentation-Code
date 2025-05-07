// import 'package:flutter/material.dart';
// import 'package:speech_to_text/speech_to_text.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ActivityScreen extends StatefulWidget {
//   final String title;
//   final List<String> phrases;

//   const ActivityScreen({
//     required this.title,
//     required this.phrases,
//     super.key,
//   });

//   @override
//   State<ActivityScreen> createState() => _ActivityScreenState();
// }

// class _ActivityScreenState extends State<ActivityScreen> {
//   final SpeechToText _speech = SpeechToText();

//   int currentIndex = 0;
//   String childResponse = "";
//   bool isListening = false;

//   List<Map<String, String>> responses = [];

//   String get currentPhrase => widget.phrases[currentIndex];

//   Future<void> _startListening() async {
//     if (isListening) {
//       await _speech.stop();
//       setState(() => isListening = false);
//       return;
//     }

//     bool available = await _speech.initialize(
//       onStatus: (status) {
//         if (status == 'notListening') {
//           setState(() => isListening = false);
//         }
//       },
//       onError: (error) {
//         setState(() => isListening = false);
//         _showSnackbar("Error: ${error.errorMsg}");
//       },
//     );

//     if (!available) {
//       _showSnackbar("Speech recognition not available.");
//       return;
//     }

//     setState(() => isListening = true);

//     await _speech.listen(
//       onResult: (result) {
//         setState(() {
//           childResponse = result.recognizedWords;
//         });
//       },
//     );
//   }

//   void _nextPhrase() async {
//     if (childResponse.trim().isEmpty) {
//       _showSnackbar("Please speak before continuing.");
//       return;
//     }

//     await _speech.stop();
//     setState(() => isListening = false);

//     final expected = _sanitizeText(currentPhrase);
//     final spoken = _sanitizeText(childResponse);
//     final isCorrect = _calculateMatch(expected, spoken) >= 0.9;

//     responses.add({
//       'expected': currentPhrase,
//       'spoken': childResponse,
//       'status': isCorrect ? 'Correct' : 'Incorrect',
//     });

//     setState(() {
//       currentIndex++;
//       childResponse = "";
//     });
//   }

//   void _submitActivity() async {
//     if (childResponse.trim().isEmpty) {
//       _showSnackbar("Please speak before submitting.");
//       return;
//     }

//     await _speech.stop();
//     setState(() => isListening = false);

//     final expected = _sanitizeText(currentPhrase);
//     final spoken = _sanitizeText(childResponse);
//     final isCorrect = _calculateMatch(expected, spoken) >= 0.9;

//     responses.add({
//       'expected': currentPhrase,
//       'spoken': childResponse,
//       'status': isCorrect ? 'Correct' : 'Incorrect',
//     });

//     await _saveProgress();
//     _showResultDialog();
//   }

//   String _sanitizeText(String text) {
//     return text.toLowerCase().replaceAll(RegExp(r"[^\w\s]"), "").trim();
//   }

//   double _calculateMatch(String a, String b) {
//     List<String> aWords = a.split(' ');
//     List<String> bWords = b.split(' ');
//     int match = 0;
//     for (int i = 0; i < aWords.length && i < bWords.length; i++) {
//       if (aWords[i] == bWords[i]) match++;
//     }
//     return match / bWords.length;
//   }

//   Future<void> _saveProgress() async {
//     final prefs = await SharedPreferences.getInstance();
//     final correct = responses.where((r) => r['status'] == 'Correct').length;
//     final total = widget.phrases.length;
//     await prefs.setString(
//       "activity_score_${widget.title.replaceAll(" ", "_")}",
//       "$correct/$total",
//     );
//   }

//   void _showResultDialog() {
//     int correct = responses.where((r) => r['status'] == 'Correct').length;
//     int total = widget.phrases.length;

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Activity Completed!"),
//         content: SizedBox(
//           width: double.maxFinite,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 "Score: $correct / $total",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.deepPurple,
//                 ),
//               ),
//               SizedBox(height: 16),
//               SizedBox(
//                 height: 300, // Set a fixed height for the list
//                 child: ListView(
//                   shrinkWrap: true,
//                   children: responses.map((entry) {
//                     return ListTile(
//                       leading: Icon(
//                         entry['status'] == 'Correct' ? Icons.check : Icons.close,
//                         color: entry['status'] == 'Correct' ? Colors.green : Colors.red,
//                       ),
//                       title: Text("Expected: ${entry['expected']}"),
//                       subtitle: Text("You said: ${entry['spoken']}"),
//                       trailing: Text(entry['status']!),
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             child: Text("Done"),
//             onPressed: () {
//               Navigator.of(context)
//                 ..pop()
//                 ..pop(); // Go back to ActivityDetailScreen
//             },
//           )
//         ],
//       ),
//     );
//   }

//   void _showSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
//   }

//   @override
//   void dispose() {
//     _speech.stop();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool isLast = currentIndex == widget.phrases.length - 1;
//     double progress = (currentIndex + 1) / widget.phrases.length;

//     return Scaffold(
//       appBar: AppBar(title: Text(widget.title)),
//       body: Center(
//         child: Card(
//           elevation: 10,
//           color: Colors.deepPurple[50],
//           margin: EdgeInsets.all(24),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//           child: Padding(
//             padding: const EdgeInsets.all(24.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 LinearProgressIndicator(
//                   value: progress,
//                   minHeight: 8,
//                   backgroundColor: Colors.deepPurple.shade100,
//                   color: Colors.deepPurple,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   "Phrase ${currentIndex + 1} of ${widget.phrases.length}",
//                   style: TextStyle(fontSize: 18, color: Colors.grey[700]),
//                 ),
//                 SizedBox(height: 12),
//                 Text(
//                   currentPhrase,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 30),
//                 ElevatedButton.icon(
//                   onPressed: isListening ? null : _startListening,
//                   icon: Icon(Icons.mic),
//                   label: Text("Speak Now"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.pink,
//                     foregroundColor: Colors.white,
//                     padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
//                     shape: StadiumBorder(),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   "You said: \"$childResponse\"",
//                   style: TextStyle(fontSize: 18),
//                 ),
//                  SizedBox(height: 8),
//                 Text(
//                   "Note: Once you speak, tap Next to move forward.",
//                   style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                 ),
//                 SizedBox(height: 30),
//                 ElevatedButton(
//                   onPressed: isLast ? _submitActivity : _nextPhrase,
//                   child: Text(isLast ? "Submit" : "Next"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     foregroundColor: Colors.white,
//                     padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
//                     shape: StadiumBorder(),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


// after adding progress report part

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ActivityScreen extends StatefulWidget {
  final String title;
  final List<String> phrases;

  const ActivityScreen({
    required this.title,
    required this.phrases,
    super.key,
  });

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final SpeechToText _speech = SpeechToText();

  int currentIndex = 0;
  String childResponse = "";
  bool isListening = false;

  List<Map<String, String>> responses = [];

  String get currentPhrase => widget.phrases[currentIndex];

  Future<void> _startListening() async {
    if (isListening) {
      await _speech.stop();
      setState(() => isListening = false);
      return;
    }

    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'notListening') {
          setState(() => isListening = false);
        }
      },
      onError: (error) {
        setState(() => isListening = false);
        _showSnackbar("Error: ${error.errorMsg}");
      },
    );

    if (!available) {
      _showSnackbar("Speech recognition not available.");
      return;
    }

    setState(() => isListening = true);

    await _speech.listen(
      onResult: (result) {
        setState(() {
          childResponse = result.recognizedWords;
        });
      },
    );
  }

  void _nextPhrase() async {
    if (childResponse.trim().isEmpty) {
      _showSnackbar("Please speak before continuing.");
      return;
    }

    await _speech.stop();
    setState(() => isListening = false);

    final expected = _sanitizeText(currentPhrase);
    final spoken = _sanitizeText(childResponse);
    final isCorrect = _calculateMatch(expected, spoken) >= 0.9;

    responses.add({
      'expected': currentPhrase,
      'spoken': childResponse,
      'status': isCorrect ? 'Correct' : 'Incorrect',
    });

    setState(() {
      currentIndex++;
      childResponse = "";
    });
  }

  void _submitActivity() async {
    if (childResponse.trim().isEmpty) {
      _showSnackbar("Please speak before submitting.");
      return;
    }

    await _speech.stop();
    setState(() => isListening = false);

    final expected = _sanitizeText(currentPhrase);
    final spoken = _sanitizeText(childResponse);
    final isCorrect = _calculateMatch(expected, spoken) >= 0.9;

    responses.add({
      'expected': currentPhrase,
      'spoken': childResponse,
      'status': isCorrect ? 'Correct' : 'Incorrect',
    });

    await _saveProgress();
    _showResultDialog();
  }

  String _sanitizeText(String text) {
    return text.toLowerCase().replaceAll(RegExp(r"[^\w\s]"), "").trim();
  }

  double _calculateMatch(String a, String b) {
    List<String> aWords = a.split(' ');
    List<String> bWords = b.split(' ');
    int match = 0;
    for (int i = 0; i < aWords.length && i < bWords.length; i++) {
      if (aWords[i] == bWords[i]) match++;
    }
    return match / bWords.length;
  }

  Future<void> _saveProgress() async {
    final correct = responses.where((r) => r['status'] == 'Correct').length;
    final total = widget.phrases.length;

    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
    final int moduleIndex = args['moduleIndex'] ?? 0;
    final int activityIndex = args['activityIndex'] ?? 0;
    final String userId = FirebaseAuth.instance.currentUser!.uid;

    final DatabaseReference ref = FirebaseDatabase.instance.ref("users/$userId/progress/module_${moduleIndex}_lesson_$activityIndex");

    await ref.set({
      'type': 'activity',
      'score': '$correct/$total',
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  void _showResultDialog() {
    int correct = responses.where((r) => r['status'] == 'Correct').length;
    int total = widget.phrases.length;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Activity Completed!"),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Score: $correct / $total",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: ListView(
                  shrinkWrap: true,
                  children: responses.map((entry) {
                    return ListTile(
                      leading: Icon(
                        entry['status'] == 'Correct' ? Icons.check : Icons.close,
                        color: entry['status'] == 'Correct' ? Colors.green : Colors.red,
                      ),
                      title: Text("Expected: ${entry['expected']}"),
                      subtitle: Text("You said: ${entry['spoken']}"),
                      trailing: Text(entry['status']!),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text("Done"),
            onPressed: () {
              Navigator.of(context)
                ..pop()
                ..pop();
            },
          )
        ],
      ),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLast = currentIndex == widget.phrases.length - 1;
    double progress = (currentIndex + 1) / widget.phrases.length;

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Card(
          elevation: 10,
          color: Colors.deepPurple[50],
          margin: EdgeInsets.all(24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: Colors.deepPurple.shade100,
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(10),
                ),
                SizedBox(height: 16),
                Text(
                  "Phrase ${currentIndex + 1} of ${widget.phrases.length}",
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                ),
                SizedBox(height: 12),
                Text(
                  currentPhrase,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: isListening ? null : _startListening,
                  icon: Icon(Icons.mic),
                  label: Text("Speak Now"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: StadiumBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "You said: \"$childResponse\"",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(
                  "Note: Once you speak, tap Next to move forward.",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: isLast ? _submitActivity : _nextPhrase,
                  child: Text(isLast ? "Submit" : "Next"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                    shape: StadiumBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
