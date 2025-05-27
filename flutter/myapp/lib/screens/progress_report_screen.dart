import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart'; // Added for PDF and CSV export
import 'package:csv/csv.dart';

class ProgressReportScreen extends StatefulWidget {
  @override
  _ProgressReportScreenState createState() => _ProgressReportScreenState();
}

class _ProgressReportScreenState extends State<ProgressReportScreen> {
  List<dynamic> progressData = [];

  @override
  void initState() {
    super.initState();
    fetchProgress();
  }

  Future<void> fetchProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final childId = prefs.getInt('child_id');

    final response = await http.get(
      Uri.parse('http://192.168.1.10:8000/api/progress/$childId'),
      // Uri.parse('http://100.64.32.53:8000/api/progress/$childId'),
      // Uri.parse('http://127.0.0.1:8000/api/progress/$childId'),
    );

    if (response.statusCode == 200) {
      setState(() {
        progressData = json.decode(response.body);
      });
    } else {
      // Handle error
      print('Failed to load progress data');
    }
  }

  // Calculate dynamic progress for each skill category based on obtained/total scores
  double calculateSkillProgress(String skillCategory) {
    final activities =
        progressData
            .where((activity) => activity['skill_category'] == skillCategory)
            .toList();
    int totalCorrect = 0;
    int totalPhrases = 0;
    for (var activity in activities) {
      totalCorrect += (activity['correct_phrases'] as int);
      totalPhrases += (activity['total_phrases'] as int);
    }
    return totalPhrases > 0 ? (totalCorrect / totalPhrases) * 100 : 0;
  }

  // Calculate total score for each skill category
  Map<String, Map<String, int>> calculateSkillScores() {
    Map<String, Map<String, int>> scores = {
      'Behavioral': {'correct': 0, 'total': 0},
      'Communicational': {'correct': 0, 'total': 0},
      'Cognitive': {'correct': 0, 'total': 0},
    };

    for (var activity in progressData) {
      String category = activity['skill_category'];
      if (scores.containsKey(category)) {
        scores[category]!['correct'] =
            scores[category]!['correct']! +
            (activity['correct_phrases'] as int);
        scores[category]!['total'] =
            scores[category]!['total']! + (activity['total_phrases'] as int);
      }
    }
    return scores;
  }

  // Export as CSV using project-mate's approach
  void exportAsCSV() {
    final skillScores = calculateSkillScores();
    List<Map<String, dynamic>> skills =
        skillScores.entries
            .map(
              (entry) => {
                'skill': entry.key,
                'progress': calculateSkillProgress(
                  entry.key,
                ).toStringAsFixed(0),
              },
            )
            .toList();

    List<Map<String, dynamic>> activities =
        progressData
            .map(
              (activity) => {
                'activity': activity['activity_name'],
                'status':
                    activity['correct_phrases'] == activity['total_phrases']
                        ? 'Completed'
                        : 'In Progress',
                'scores': [
                  activity['correct_phrases'],
                  0,
                  0,
                ], // Adjust scores as per your data; only correct_phrases available
                'skill': activity['skill_category'],
              },
            )
            .toList();

    List<List<dynamic>> csvData = [
      ['Skill', 'Progress (%)'],
      ...skills.map((s) => [s['skill'], s['progress']]),
      [],
      [
        'Activity',
        'Status',
        'Score',
        'Skill',
      ], // Simplified since we only have one score (correct_phrases)
      ...activities.map(
        (a) => [
          a['activity'],
          a['status'],
          '${a['scores'][0]}/${progressData.firstWhere((act) => act['activity_name'] == a['activity'])['total_phrases']}',
          a['skill'],
        ],
      ),
    ];

    final csv = const ListToCsvConverter().convert(csvData);
    Printing.sharePdf(
      bytes: Uint8List.fromList(csv.codeUnits),
      filename: 'progress_report.csv',
    );
  }

  // Export as PDF using project-mate's approach
  void exportAsPDF() async {
    final pdf = pw.Document();
    final skillScores = calculateSkillScores();
    List<Map<String, dynamic>> skills =
        skillScores.entries
            .map(
              (entry) => {
                'skill': entry.key,
                'progress': calculateSkillProgress(
                  entry.key,
                ).toStringAsFixed(0),
              },
            )
            .toList();

    List<Map<String, dynamic>> activities =
        progressData
            .map(
              (activity) => {
                'activity': activity['activity_name'],
                'status':
                    activity['correct_phrases'] == activity['total_phrases']
                        ? 'Completed'
                        : 'In Progress',
                'scores': [
                  activity['correct_phrases'],
                  0,
                  0,
                ], // Adjust scores as per your data
                'skill': activity['skill_category'],
              },
            )
            .toList();

    final lastUpdated =
        DateTime.now().toString(); // Current timestamp for last updated

    pdf.addPage(
      pw.MultiPage(
        build:
            (pw.Context context) => [
              pw.Text(
                'ASD Progress Report',
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Last Updated: $lastUpdated',
                style: pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Skills Progress',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 5),
              ...skills.map((s) => pw.Text('${s['skill']}: ${s['progress']}%')),
              pw.SizedBox(height: 10),
              pw.Text(
                'Activities',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 5),
              ...activities.map(
                (a) => pw.Column(
                  children: [
                    pw.Text(
                      '${a['activity']} - ${a['status']} (${a['skill']})',
                    ),
                    pw.Text(
                      'Score: ${a['scores'][0]}/${progressData.firstWhere((act) => act['activity_name'] == a['activity'])['total_phrases']}',
                    ),
                    pw.SizedBox(height: 5),
                  ],
                ),
              ),
            ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    final skillCategories = calculateSkillScores().keys.toList();
    final skillScores = calculateSkillScores();

    // Define colors for each skill category
    final Map<String, Color> skillColors = {
      'Behavioral': Colors.red,
      'Communicational': Colors.deepPurple,
      'Cognitive': Colors.green,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ASD Progress Report',
          style: TextStyle(
            color: Colors.white, // Title text color white
            fontWeight: FontWeight.bold, // Bold title
          ),
        ),
        centerTitle: true, // Center the title
        backgroundColor: Colors.blue, // AppBar background color
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white, // Back icon color white
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Skill progress bars
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Skill Progress',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ...skillCategories.map(
                  (skill) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 140,
                          child: Text(
                            skill,
                            style: TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: calculateSkillProgress(skill) / 100,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: skillColors[skill] ?? Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          '${calculateSkillProgress(skill).toStringAsFixed(0)}%',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // Summary box for skill scores
                Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  color: Color.fromARGB(
                    255,
                    122,
                    171,
                    232,
                  ), // Light navy blue background
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Skill Scores',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // White text
                          ),
                        ),
                        ...skillScores.entries.map(
                          (entry) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(entry.key, style: TextStyle(fontSize: 16)),
                                Text(
                                  '${entry.value['correct']}/${entry.value['total']}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: progressData.length,
              itemBuilder: (context, index) {
                final activity = progressData[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity['activity_name'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Skill: ${activity['skill_category']}',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          '${activity['correct_phrases']}/${activity['total_phrases']}',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Download buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: exportAsCSV,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.green, // Green background for CSV button
                  ),
                  child: Text(
                    'Download CSV',
                    style: TextStyle(
                      color: Colors.white,
                    ), // White text for contrast
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: exportAsPDF,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.red, // Red background for PDF button
                  ),
                  child: Text(
                    'Download PDF',
                    style: TextStyle(
                      color: Colors.white,
                    ), // White text for contrast
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
