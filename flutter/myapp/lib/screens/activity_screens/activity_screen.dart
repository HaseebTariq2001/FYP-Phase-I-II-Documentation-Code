import 'package:flutter/material.dart';
import 'package:myapp/screens/Learning%20and%20lesson/child_dashboard_screen.dart'
    show LearningTabScreen;
import 'package:myapp/screens/activity_screens/activity_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;
import 'package:speech_to_text/speech_to_text.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myapp/services/notification_service.dart';   // ✅ NEW


class ActivityScreen extends StatefulWidget {
  final String title;
  final String skill;
  final List<String> phrases;

final int lessonIndex;                         // ✅ NEW: add this

const ActivityScreen({
  super.key,
  required this.title,
  required this.skill,
  required this.phrases,
  required this.lessonIndex,                   // ✅ NEW: add this
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

// ✅ Add your initState here:
  // @override
  // void initState() {
  //   super.initState();
  //   NotificationService.cancelReminder(widget.lessonIndex);   // ✅ NEW
  // }
  @override
void initState() {
  super.initState();

  // ✅ Cancel reminder when activity starts
  NotificationService.cancelReminder(widget.lessonIndex).then((_) {
    // ✅ Show SnackBar for confirmation (for debug only)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Activity reminder cancelled successfully"),
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  });
}


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

      /// ✅ ADD THIS
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
    final prefs = await SharedPreferences.getInstance();
    final childId = prefs.getInt('child_id');

    final correct =
        responses
            .where((r) => r['status'] != null && r['status'] == 'Correct')
            .length;

    // final correct = responses.where((r) => r['status'] == 'Correct').length;
    final total = widget.phrases.length;

    await http.post(
      Uri.parse('http://127.0.0.1:8000/api/save-activity'),
      // Uri.parse('http://100.64.64.88:8000/api/save-activity'),
      // Uri.parse('http://192.168.1.6:8000/api/save-activity'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'child_id': childId,
        'activity_name': widget.title,
        'skill_category': widget.skill,
        'correct_phrases': correct,
        'total_phrases': total,
      }),
    );
  }

  void _showResultDialog() {
    /// ✅ Null safe check for responses
    int correct =
        responses
            .where((r) => r['status'] != null && r['status'] == 'Correct')
            .length;
    // int correct = responses.where((r) => r['status'] == 'Correct').length;
    int total = widget.phrases.length;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Activity Completed!"),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Score: $correct / $total",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 300,
                    child: ListView(
                      shrinkWrap: true,
                      children:
                          responses.map((entry) {
                            return ListTile(
                              leading: Icon(
                                entry['status'] == 'Correct'
                                    ? Icons.check
                                    : Icons.close,
                                color:
                                    entry['status'] == 'Correct'
                                        ? Colors.green
                                        : Colors.red,
                              ),
                              title: Text("Expected: ${entry['expected']}"),
                              subtitle: Text("You said: ${entry['spoken']}"),
                              // trailing: Text(entry['status']!),
                              trailing: Text(entry['status'] ?? ''),

                              /// ✅ Safe access
                            );
                          }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text("Done"),
                // onPressed: () => Navigator.of(context).pop(),
                onPressed:
                    () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ActivityDetailScreen(),
                      ),
                    ),
              ),
            ],
          ),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
    // NotificationService.cancelReminder(widget.lessonIndex); 
  }

  @override
  Widget build(BuildContext context) {
    bool isLast = currentIndex == widget.phrases.length - 1;
    double progress = (currentIndex + 1) / widget.phrases.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LearningTabScreen()),
            );
          },
        ),
      ),
      body: Center(
        child: Card(
          elevation: 10,
          color: Colors.deepPurple[50],
          margin: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
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
                const SizedBox(height: 16),
                Text(
                  "Phrase ${currentIndex + 1} of ${widget.phrases.length}",
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                ),
                const SizedBox(height: 12),
                Text(
                  currentPhrase,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: isListening ? null : _startListening,
                  icon: const Icon(Icons.mic),
                  label: const Text("Speak Now", style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: const StadiumBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "You said: \"$childResponse\"",
                  style: const TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(
                  "Note: Once you speak, tap Next to move forward.",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                    onPressed: isLast ? _submitActivity : _nextPhrase,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 14,
                      ),
                      shape: const StadiumBorder(),
                    ),
                    child: Text(
                      isLast ? "Submit" : "Next",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                         fontSize: 16,
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
}
