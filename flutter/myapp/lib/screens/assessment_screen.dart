import 'package:flutter/material.dart';
import '../models/cars_question.dart';
import '../services/api_service.dart';
import 'result_screen.dart';
import 'analyzing_screen.dart';

class AssessmentScreen extends StatefulWidget {
  final String childName;

  const AssessmentScreen({super.key, required this.childName});

  @override
  AssessmentScreenState createState() => AssessmentScreenState();
}

class AssessmentScreenState extends State<AssessmentScreen> {
  final List<CarsQuestion> questions = [
    CarsQuestion(
      question: "1. Relationship with others",
      scores: [1, 1.5, 2, 2.5, 3, 3.5, 4],
      descriptions: [
        "Without Difficulties A certain shyness",
        "",
        "Avoid eye contact,Demanding, Excessively shy, Excessive parental dependence",
        "",
        "Distant attitude, Difficulties in interaction",
        "",
        "Very distant, Very little interaction",
      ],
    ),
    CarsQuestion(
      question: "2. Imitation skills",
      scores: [1, 1.5, 2, 2.5, 3, 3.5, 4],
      descriptions: [
        "Without difficulties",
        "",
        "Imitates behaviors simple (clapping/ sounds)",
        "",
        "Sometimes imitates the adult with great effort",
        "",
        "Rarely or never imitates, even with the help of an adult",
      ],
    ),
    CarsQuestion(
      question: "3. Affection",
      scores: [1, 1.5, 2, 2.5, 3, 3.5, 4],
      descriptions: [
        "Without difficulties",
        "",
        "Occasionally, inappropriate types and degrees of emotional response",
        "",
        "Inappropriate emotional response (excessive or insufficient)",
        "",
        "Rarely answer appropriate (affective rigidity)",
      ],
    ),
    CarsQuestion(
      question: "4. Use of the body",
      scores: [1, 1.5, 2, 2.5, 3, 3.5, 4],
      descriptions: [
        "He/She moves like a child of his age",
        "",
        "Clumsiness, repetitive movements, poor coordination or unusual movements",
        "",
        "Strange finger movements, peculiar finger and body posture. Staring. Self-harm.",
        "",
        "Greater intensity and persistence of the behaviors described in point 3",
      ],
    ),
    CarsQuestion(
      question: "5. Use of Objects",
      scores: [1, 1.5, 2, 2.5, 3, 3.5, 4],
      descriptions: [
        "Interest in toys and other objects that are played with appropriately",
        "",
        "May show atypical interest or play in an excessively childish manner",
        "",
        "Little interest in toys or absorbed in them. Fascinated by thelight on an object. Performs repetitive movements",
        "",
        "Greater intensity and frequency of the behaviors described in point 3.",
      ],
    ),
    CarsQuestion(
      question: "6. Adaptation to change",
      scores: [1, 1.5, 2, 2.5, 3, 3.5, 4],
      descriptions: [
        "Appropriate response to the changes",
        "",
        "Persistence in the activity or with the same objects even with adult intervention",
        "",
        "Active resistance to changes in routine (boredom or sadness)",
        "",
        "Severe reactions to change (anger or lack of cooperation)",
      ],
    ),
    CarsQuestion(
      question: "7. Visual Response",
      scores: [1, 1.5, 2, 2.5, 3, 3.5, 4],
      descriptions: [
        "Adequate visual response",
        "",
        "Forgetfulness to look at objects; more interest in mirrors or a light than in their peers. Some avoidance of eye gaze",
        "",
        "Fixed gaze, averts gaze, looks at objects from an unusual angle. Holds objects very close to the eyes",
        "",
        "He stubbornly avoids people's gaze. Extreme behaviors of point 3.",
      ],
    ),
    CarsQuestion(
      question: "8. Auditory Response",
      scores: [1, 1.5, 2, 2.5, 3, 3.5, 4],
      descriptions: [
        "Adequate auditory responses",
        "",
        "There may be a lack of response or a slightly extreme reaction to certain sounds.",
        "",
        "Variant response: Often ignoring a sound. Becoming frightened or covering one's ears even when it is a familiar sound.",
        "",
        "It can react in extreme mode or not reacting to frequent sounds",
      ],
    ),
    CarsQuestion(
      question: "9. Taste, smell, and use and tactile response:",
      scores: [1, 1.5, 2, 2.5, 3, 3.5, 4],
      descriptions: [
        "Without difficulties",
        "",
        "Imitates behaviors simple (clapping/ sounds)",
        "",
        "Sometimes imitates the adult with great effort",
        "",
        "Rarely or never imitates, even with the help of an adult",
      ],
    ),
    CarsQuestion(
      question: "10. Anxiety and fear",
      scores: [1, 1.5, 2, 2.5, 3, 3.5, 4],
      descriptions: [
        "Appropriate conduct anxiety for both situations or very little fear than would be typical compared to peers of a younger children in a similar situation",
        "",
        "Occassionally shows excessive fear or anxiety or very little fear than would be typical compared to peers of a younger children in a similar situation",
        "",
        "Shows more or less fear or very little fear than would be typical compared to peers of a younger children in a similar situation",
        "",
        "May fail to perceive dangers that other children of his/her age avoid",
      ],
    ),
    CarsQuestion(
      question: "11. Verbal Communication",
      scores: [1, 1.5, 2, 2.5, 3, 3.5, 4],
      descriptions: [
        "Adequate verbal communication",
        "",
        "Global speech delay. Most speech is meaningless. There may be repetition or reversal of pronouns. Uses peculiar words or slang.  ",
        "",
        "There maybe absence of speech. . Childish screaming and mixing of language with strange sounds or peculiar animal-like sense and language",
        "",
        "No use of speech with speech. If spoken, there may be meaning. Childish screaming and mixing of language with strange sounds or peculiar animal-like sense and language.(excessive questions, repetition, or inversion of pronouns)",
      ],
    ),
    CarsQuestion(
      question: "12. Nonverbal Communication",
      scores: [1, 1.5, 2, 2.5, 3, 3.5, 4],
      descriptions: [
        "Age appropriate nonverbal communication",
        "",
        "Immature use. May pointing vaguely (worse then children of his/her age)",
        "",
        "Generally unable to express needs or desires without speaking. Does not understand the verbal communication of others",
        "",
        "He/She only uses strange or peculiar gestures that are apparently meaningless. Does not pick up on gestures or facial expressions of others.",
      ],
    ),
    CarsQuestion(
      question: "13. Activity Level",
      scores: [1, 1.5, 2, 2.5, 3, 3.5, 4],
      descriptions: [
        "Normal activity level May be active or a little “lazy” and slow for his/her age.",
        "",
        "Activity level slightly interferes with its functioning",
        "",
        "Quite active and difficult to restrain. He may have boundless energy and struggle to sleep at night. Conversely, he may be very lethargic and require a lot of effort to move",
        "",
        "He/She exhibits extremes of activity and can change from one extreme to the other.",
      ],
    ),
    CarsQuestion(
      question: "14. Level and consistency of the intellectual response",
      scores: [1, 1.5, 2, 2.5, 3, 3.5, 4],
      descriptions: [
        "Normal Intelligence",
        "",
        "Not as bright as the overall children of their age.",
        "",
        "Less bright skills then his/her peers",
        "",
        "May Delayed in all areas function better than one or more areas typical child his/her age in one or more areas",
      ],
    ),
    CarsQuestion(
      question: "15. Imitation skills",
      scores: [1, 1.5, 2, 2.5, 3, 3.5, 4],
      descriptions: [
        "Does not show any symptoms or mild degree of autism characteristics of autism.",
        "",
        "Shows only some of the symptoms or mild degree of autism characteristics of autism.",
        "",
        "Shows a number of symptoms or a moderate degree of autism",
        "",
        "Shows many symptoms or an extreme degree of autism",
      ],
    ),
  ]; // Initialize as an empty list or provide actual data

  final Map<String, double> selectedScores = {}; // User selected scores

  // Future<void> submitAssessment() async {
  //   // Check if all questions are answered before submitting
  //   if (selectedScores.length != questions.length) {
  //     // Show alert if not all questions are answered
  //     showDialog(
  //       context: context,
  //       builder:
  //           (context) => AlertDialog(
  //             title: Text("Incomplete Assessment"),
  //             content: Text("Please answer all questions before submitting."),
  //             actions: [
  //               TextButton(
  //                 onPressed: () => Navigator.pop(context),
  //                 child: Text("OK"),
  //               ),
  //             ],
  //           ),
  //     );
  //     return; // Prevent API call if incomplete
  //   }

  //   List<double> scores =
  //       questions.map((q) => selectedScores[q.question] ?? 1).toList();
  //   print("Scores selected: $scores");

  //   try {
  //     var result = await ApiService.assessAutism(scores);
  //     print("API Result: $result");

  //     if (!mounted) return;

  //     // added this code to send the child name to result screen
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder:
  //             (context) => ResultScreen(
  //               result: result.toString(),
  //               childName: widget.childName, // 🔥 This is the missing piece
  //             ),
  //       ),
  //     );
  //   } catch (e) {
  //     // Handle API call failure gracefully
  //     showDialog(
  //       context: context,
  //       builder:
  //           (context) => AlertDialog(
  //             title: Text("Submission Failed"),
  //             content: Text(
  //               "Unable to submit assessment. Please check your connection and try again.",
  //             ),
  //             actions: [
  //               TextButton(
  //                 onPressed: () => Navigator.pop(context),
  //                 child: Text("OK"),
  //               ),
  //             ],
  //           ),
  //     );
  //   }
  // }

  Future<void> submitAssessment() async {
    if (selectedScores.length != questions.length) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text("Incomplete Assessment"),
              content: Text("Please answer all questions before submitting."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("OK"),
                ),
              ],
            ),
      );
      return;
    }

    List<double> scores =
        questions.map((q) => selectedScores[q.question] ?? 1).toList();
    print("Scores selected: $scores");

    try {
      // 🔄 Show the analyzing animation screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AnalyzingScreen()),
      );

      // ⏳ Simulate some wait time (optional but makes animation feel smoother)
      await Future.delayed(const Duration(seconds: 3));

      var result = await ApiService.assessAutism(scores);
      print("API Result: $result");

      if (!mounted) return;

      // ❌ Remove the analyzing screen
      Navigator.pop(context);

      // ✅ Navigate to result screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => ResultScreen(
                result: result.toString(),
                childName: widget.childName,
              ),
        ),
      );
    } catch (e) {
      Navigator.pop(
        context,
      ); // make sure to close analyzing screen on error too

      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text("Submission Failed"),
              content: Text(
                "Unable to submit assessment. Please check your connection and try again.",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("OK"),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        title: Center(
          child: Text(
            "CARS Assessment",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            // Info Box for Intermediate Scores
            Card(
              color: Colors.blue[100],
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[900]),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Intermediate scores (e.g. 2.5) are selected when the behavior appears in an intermediate position between two categories.",
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            ...questions.map((q) => _buildQuestionCard(q)),

            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: submitAssessment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Submit Assessment",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(CarsQuestion question) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.question,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Column(
              children: List.generate(question.scores.length, (index) {
                return RadioListTile<double>(
                  title: Text(
                    "${question.scores[index]} - ${question.descriptions[index]}",
                    style: TextStyle(fontSize: 16),
                  ),
                  value: question.scores[index],
                  groupValue: selectedScores[question.question],
                  onChanged: (value) {
                    setState(() {
                      selectedScores[question.question] = value!;
                    });
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
