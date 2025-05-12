// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:csv/csv.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// class ProgressReportScreen extends StatefulWidget {
//   final int childId;   // ✅ pass childId (from database)

//   const ProgressReportScreen({super.key, required this.childId});

//   @override
//   State<ProgressReportScreen> createState() => _ProgressReportScreenState();
// }

// class _ProgressReportScreenState extends State<ProgressReportScreen> {
//   final List<Map<String, dynamic>> skills = [
//     {'skill': 'Behavioral', 'progress': 0},
//     {'skill': 'Communicational', 'progress': 0},
//     {'skill': 'Cognitive', 'progress': 0},
//   ];

//   final List<Map<String, dynamic>> activities = [
//     {'activity': 'Greetings and Introductions', 'status': 'Not Started', 'scores': [0, 0, 0], 'skill': 'Communicational'},
//     {'activity': 'Asking for Help', 'status': 'Not Started', 'scores': [0, 0, 0], 'skill': 'Communicational'},
//     {'activity': 'Expressing Needs', 'status': 'Not Started', 'scores': [0, 0, 0], 'skill': 'Communicational'},
//     {'activity': 'Expressing Emotions', 'status': 'Not Started', 'scores': [0, 0, 0], 'skill': 'Communicational'},
//     {'activity': 'Talking with Friends', 'status': 'Not Started', 'scores': [0, 0, 0], 'skill': 'Communicational'},
//     {'activity': 'Understanding Emotions', 'status': 'Not Started', 'scores': [0, 0, 0], 'skill': 'Behavioral'},
//     {'activity': 'Emotion Sorting', 'status': 'Not Started', 'scores': [0, 0, 0], 'skill': 'Behavioral'},
//     {'activity': 'Tap Good Behavior', 'status': 'Not Started', 'scores': [0, 0, 0], 'skill': 'Behavioral'},
//     {'activity': 'Learn Your Morning Routine', 'status': 'Not Started', 'scores': [0, 0, 0], 'skill': 'Cognitive'},
//     {'activity': 'Going to School Routine', 'status': 'Not Started', 'scores': [0, 0, 0], 'skill': 'Cognitive'},
//   ];

//   String lastUpdated = '';

//   @override
//   void initState() {
//     super.initState();
//     loadData();
//   }

//   Future<void> loadData() async {
//     final response = await http.get(Uri.parse(
//         'http://100.64.49.112:8000/api/child-progress/${widget.childId}'));

//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//       setState(() {
//         for (var activity in activities) {
//           var record = data.firstWhere(
//             (item) => item['activity_name'] == activity['activity'],
//             orElse: () => null,
//           );
//           if (record != null) {
//             activity['status'] = record['completion_status'] ?? 'Not Started';
//             activity['scores'] = [
//               record['correct_phrases'] ?? 0,
//               record['total_phrases'] ?? 0,
//               record['extra_info'] ?? 0,
//             ];
//           }
//         }
//         calculateProgress();
//       });
//     }
//   }

//   void calculateProgress() {
//     for (var skill in skills) {
//       final related = activities.where((a) => a['skill'] == skill['skill']).toList();
//       if (related.isNotEmpty) {
//         final total = related
//             .map((a) => a['scores'].reduce((a, b) => a + b) / a['scores'].length)
//             .reduce((a, b) => a + b);
//         skill['progress'] = (total / related.length).round();
//       }
//     }
//     lastUpdated = DateFormat('dd MMM yyyy – hh:mm a').format(DateTime.now());
//   }

//   Future<void> saveData(String activityName, String status, List<int> scores, String skill) async {
//     await http.post(
//       Uri.parse('http://100.64.49.112:8000/api/save-activity'),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({
//         'child_id': widget.childId,
//         'activity_name': activityName,
//         'skill_category': skill,
//         'completion_status': status,
//         'correct_phrases': scores[0],
//         'total_phrases': scores[1],
//         'extra_info': scores[2],
//       }),
//     );

//     setState(() => calculateProgress());
//   }

//   void exportAsCSV() {
//     List<List<dynamic>> csvData = [
//       ['Skill', 'Progress (%)'],
//       ...skills.map((s) => [s['skill'], s['progress']]),
//       [],
//       ['Activity', 'Status', 'Task 1', 'Task 2', 'Task 3', 'Skill'],
//       ...activities.map((a) => [
//             a['activity'],
//             a['status'],
//             a['scores'][0],
//             a['scores'][1],
//             a['scores'][2],
//             a['skill'],
//           ]),
//     ];

//     final csv = const ListToCsvConverter().convert(csvData);
//     Printing.sharePdf(
//         bytes: Uint8List.fromList(csv.codeUnits), filename: 'progress_report.csv');
//   }

//   void exportAsPDF() async {
//     final pdf = pw.Document();
//     pdf.addPage(
//       pw.MultiPage(
//         build: (pw.Context context) => [
//           pw.Text('ASD Progress Report',
//               style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
//           pw.SizedBox(height: 10),
//           pw.Text('Last Updated: $lastUpdated', style: pw.TextStyle(fontSize: 12)),
//           pw.SizedBox(height: 10),
//           pw.Text('Skills Progress',
//               style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
//           pw.SizedBox(height: 5),
//           ...skills.map((s) => pw.Text('${s['skill']}: ${s['progress']}%')),
//           pw.SizedBox(height: 10),
//           pw.Text('Activities',
//               style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
//           pw.SizedBox(height: 5),
//           ...activities.map((a) => pw.Column(children: [
//                 pw.Text('${a['activity']} - ${a['status']} (${a['skill']})'),
//                 pw.Text('Scores: ${a['scores'][0]}, ${a['scores'][1]}, ${a['scores'][2]}'),
//                 pw.SizedBox(height: 5),
//               ])),
//         ],
//       ),
//     );
//     await Printing.layoutPdf(onLayout: (format) => pdf.save());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('ASD Progress Report')),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Skill Progress',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             ...skills.map((skill) => Padding(
//                   padding: const EdgeInsets.only(bottom: 16),
//                   child: _ProgressBar(skill: skill['skill'], progress: skill['progress']),
//                 )),
//             const SizedBox(height: 24),
//             const Text('Activities',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             ...activities.map((activity) => Padding(
//                   padding: const EdgeInsets.only(bottom: 16),
//                   child: _ActivityCard(
//                     activity: activity['activity'],
//                     status: activity['status'],
//                     scores: List<int>.from(activity['scores']),
//                     skill: activity['skill'],
//                     onStatusChange: (newStatus) {
//                       setState(() {
//                         activity['status'] = newStatus;
//                       });
//                       saveData(activity['activity'], newStatus, activity['scores'], activity['skill']);
//                     },
//                     onScoreChange: (index, value) {
//                       setState(() {
//                         activity['scores'][index] = value;
//                       });
//                       saveData(activity['activity'], activity['status'], activity['scores'], activity['skill']);
//                     },
//                   ),
//                 )),
//             const SizedBox(height: 16),
//             Text('Last Updated: $lastUpdated', style: const TextStyle(fontSize: 14)),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: exportAsCSV,
//                   icon: const Icon(Icons.table_chart),
//                   label: const Text('Download CSV'),
//                 ),
//                 const SizedBox(width: 12),
//                 ElevatedButton.icon(
//                   onPressed: exportAsPDF,
//                   icon: const Icon(Icons.picture_as_pdf),
//                   label: const Text('Download PDF'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _ProgressBar extends StatelessWidget {
//   final String skill;
//   final int progress;

//   const _ProgressBar({required this.skill, required this.progress});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(skill,
//                 style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
//             Text('$progress%',
//                 style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
//           ],
//         ),
//         const SizedBox(height: 4),
//         LinearProgressIndicator(value: progress / 100, minHeight: 8),
//       ],
//     );
//   }
// }

// class _ActivityCard extends StatelessWidget {
//   final String activity;
//   final String status;
//   final List<int> scores;
//   final String skill;
//   final ValueChanged<String> onStatusChange;
//   final void Function(int index, int value) onScoreChange;

//   const _ActivityCard({
//     required this.activity,
//     required this.status,
//     required this.scores,
//     required this.skill,
//     required this.onStatusChange,
//     required this.onScoreChange,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                   child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                     Text(activity,
//                         style: const TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.w600)),
//                     Text('Status: $status (Skill: $skill)',
//                         style: TextStyle(fontSize: 14, color: Colors.grey[600])),
//                   ])),
//               DropdownButton<String>(
//                 value: status,
//                 items: ['Not Started', 'In Progress', 'Completed']
//                     .map((s) => DropdownMenuItem(value: s, child: Text(s)))
//                     .toList(),
//                 onChanged: (value) {
//                   if (value != null) onStatusChange(value);
//                 },
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           const Text('Activity Scores',
//               style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
//           Row(
//             children: List.generate(
//               3,
//               (index) => Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 4),
//                   child: TextFormField(
//                     initialValue: scores[index].toString(),
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(labelText: 'Task ${index + 1}'),
//                     onChanged: (value) {
//                       final val = int.tryParse(value) ?? 0;
//                       onScoreChange(index, val.clamp(0, 100));
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ]),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      // Uri.parse('http://127.0.0.1:8000/api/progress/$childId'),
      Uri.parse('http://100.64.32.53:8000/api/progress/$childId'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Progress Report')),
        body: ListView.builder(
          itemCount: progressData.length,
          itemBuilder: (context, index) {
            final activity = progressData[index];
            return ListTile(
              title: Text(activity['activity_name']),
              subtitle: Text('Skill: ${activity['skill_category']}'),
              trailing: Text(
                  '${activity['correct_phrases']}/${activity['total_phrases']}'),
            );
          },
        ));
  }
}
