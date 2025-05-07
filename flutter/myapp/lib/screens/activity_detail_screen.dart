import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'activity_screen.dart';

class ActivityDetailScreen extends StatefulWidget {
  const ActivityDetailScreen({super.key});

  @override
  _ActivityDetailScreenState createState() => _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends State<ActivityDetailScreen> {
  final List<Map<String, dynamic>> lessons = [
    {
      'title': "Greetings and Introductions",
      'image': 'assets/greeting.jpg',
      'phrases': [
        "Hello", "Good morning", "How are you?", "I am fine, thank you",
        "What’s your name?", "My name is Alex", "Nice to meet you", "See you later"
      ],
    },
    {
      'title': "Asking for Help",
      'image': 'assets/asking_for_help.png',
      'phrases': [
        "Can you help me?", "I need help", "Please open this", "I don’t understand",
        "Can you tie my shoes?", "Please pass that to me", "I need a teacher", "Can you show me how to do it?"
      ],
    },
    {
      'title': "Expressing Needs",
      'image': 'assets/expressing_needs.webp',
      'phrases': [
        "I want juice", "I am hungry", "I need to go to the bathroom", "I want to sit down",
        "I need to take a break", "I feel tired", "I want to go home", "I want my toy"
      ],
    },
    {
      'title': "Expressing Emotions",
      'image': 'assets/expressing_emotions.jpg',
      'phrases': [
        "I feel happy", "I am sad", "I am angry", "I am scared",
        "I am excited", "I feel nervous", "I feel sleepy", "That made me upset"
      ],
    },
    {
      'title': "Talking with Friends",
      'image': 'assets/talking_with_friends.jpg',
      'phrases': [
        "Can I play with you?", "Let’s play together", "That’s my turn", "Good job!",
        "I like your toy", "Let’s build something", "Do you want to play again?", "You go first"
      ],
    },
  ];

  int unlockedLesson = 0;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      unlockedLesson = prefs.getInt('unlockedLesson') ?? 0;
    });
  }

  void _handleLessonTap(int index) {
    if (index >= unlockedLesson) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please complete the previous lesson first.")),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ActivityScreen(
            title: lessons[index]['title'],
            phrases: List<String>.from(lessons[index]['phrases']),
          ),
        ),
      ).then((_) async {
        final prefs = await SharedPreferences.getInstance();
        final key = "activity_score_${lessons[index]['title'].replaceAll(" ", "_")}";
        final score = prefs.getString(key) ?? "";
        if (score.isNotEmpty) {
          final parts = score.split('/');
          if (parts.length == 2 && int.tryParse(parts[0]) == int.tryParse(parts[1])) {
            if (unlockedLesson == index + 1) {
              await prefs.setInt('unlockedLesson', unlockedLesson + 1);
              setState(() => unlockedLesson = unlockedLesson + 1);
            }
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Repeat After Me")),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          final lesson = lessons[index];
          final isLocked = index >= unlockedLesson;

          return Card(
            elevation: 3,
            margin: EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: isLocked ? Colors.grey[200] : const Color.fromARGB(255, 183, 58, 177),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  lesson['image'],
                  width: 70,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                "Activity ${index + 1}",
                style: TextStyle(color: isLocked ? Colors.black54 : Colors.white),
              ),
              subtitle: Text(
                lesson['title'],
                style: TextStyle(color: isLocked ? Colors.black45 : Colors.white70),
              ),
              trailing: Icon(
                isLocked ? Icons.lock_outline : Icons.play_arrow,
                color: isLocked ? Colors.grey : Colors.white,
              ),
              onTap: () => _handleLessonTap(index),
            ),
          );
        },
      ),
    );
  }
}
