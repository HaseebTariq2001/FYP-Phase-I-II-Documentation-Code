// // import 'package:flutter/material.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:intl/intl.dart';
// // import 'dart:typed_data';
// // import 'package:csv/csv.dart';
// // import 'package:pdf/widgets.dart' as pw;
// // import 'package:printing/printing.dart';

// // class ProgressReportScreen extends StatefulWidget {
// //   const ProgressReportScreen({super.key});

// //   @override
// //   State<ProgressReportScreen> createState() => _ProgressReportScreenState();
// // }

// // class _ProgressReportScreenState extends State<ProgressReportScreen> {
// //   final List<String> moduleTitles = [
// //     'Communication Skills',
// //     'Cognitive Skills',
// //     'Social Interaction',
// //   ];

// //   final List<Color> moduleColors = [
// //     Colors.purple,
// //     Colors.blue,
// //     Colors.teal,
// //   ];

// //   final List<List<String>> activityNames = [
// //     [
// //       'Greetings and Introductions',
// //       'Asking for Help',
// //       'Expressing Needs',
// //       'Expressing Emotions',
// //       'Talking with Friends',
// //     ],
// //     [
// //       'Learn Your Morning Routine',
// //       'Going to School Routine',
// //       'Back from School Routine',
// //     ],
// //     [
// //       'Activity 1',
// //       'Activity 2',
// //       'Activity 3',
// //     ],
// //   ];

// //   Map<String, String> scores = {};
// //   String lastUpdated = '';

// //   @override
// //   void initState() {
// //     super.initState();
// //     loadScores();
// //   }

// //   Future<void> loadScores() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     Map<String, String> loaded = {};

// //     for (int m = 0; m < moduleTitles.length; m++) {
// //       for (int a = 0; a < activityNames[m].length; a++) {
// //         String key = 'lesson_score_module${m}_lesson$a';
// //         loaded[key] = prefs.getString(key) ?? '-';
// //       }
// //     }

// //     setState(() {
// //       scores = loaded;
// //       lastUpdated = DateFormat('dd MMM yyyy – hh:mm a').format(DateTime.now());
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text("Progress Report")),
// //       body: Column(
// //         children: [
// //           Expanded(
// //             child: SingleChildScrollView(
// //               scrollDirection: Axis.horizontal,
// //               child: Container(
// //                 width: MediaQuery.of(context).size.width,
// //                 padding: const EdgeInsets.all(12),
// //                 child: Table(
// //                   border: TableBorder.all(color: Colors.black),
// //                   columnWidths: const {
// //                     0: FixedColumnWidth(160),
// //                     1: FlexColumnWidth(),
// //                     2: FixedColumnWidth(110),
// //                   },
// //                   defaultVerticalAlignment: TableCellVerticalAlignment.middle,
// //                   children: _buildFullTableRows(),
// //                 ),
// //               ),
// //             ),
// //           ),
// //           const SizedBox(height: 10),
// //           Text("Last Updated: $lastUpdated"),
// //           const SizedBox(height: 10),
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               ElevatedButton.icon(
// //                 onPressed: exportAsCSV,
// //                 icon: const Icon(Icons.table_chart),
// //                 label: const Text("Export CSV"),
// //               ),
// //               const SizedBox(width: 12),
// //               ElevatedButton.icon(
// //                 onPressed: exportAsPDF,
// //                 icon: const Icon(Icons.picture_as_pdf),
// //                 label: const Text("Export PDF"),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 20),
// //         ],
// //       ),
// //     );
// //   }

// //   List<TableRow> _buildFullTableRows() {
// //     List<TableRow> rows = [];

// //     rows.add(
// //       TableRow(
// //         decoration: const BoxDecoration(color: Colors.grey),
// //         children: const [
// //           Padding(
// //             padding: EdgeInsets.all(8),
// //             child: Text('Modules', style: TextStyle(fontWeight: FontWeight.bold)),
// //           ),
// //           Padding(
// //             padding: EdgeInsets.all(8),
// //             child: Text('Activities', style: TextStyle(fontWeight: FontWeight.bold)),
// //           ),
// //           Padding(
// //             padding: EdgeInsets.all(8),
// //             child: Text('Score (%)', style: TextStyle(fontWeight: FontWeight.bold)),
// //           ),
// //         ],
// //       ),
// //     );

// //     for (int m = 0; m < moduleTitles.length; m++) {
// //       final List<String> activities = activityNames[m];
// //       final int activitySpan = activities.length;

// //       for (int a = 0; a < activitySpan; a++) {
// //         String key = 'lesson_score_module${m}_lesson$a';
// //         String score = scores[key] ?? '-';

// //         String progressText = score;
// //         String symbol = '';
// //         if (score.contains('/')) {
// //           final parts = score.split('/');
// //           final num = int.tryParse(parts[0]) ?? 0;
// //           final total = int.tryParse(parts[1]) ?? 1;
// //           final percent = ((num / total) * 100).toStringAsFixed(0);
// //           symbol = (num / total) >= 0.9 ? ' ✅' : ' ❌';
// //           progressText = "$score ($percent%)$symbol";
// //         }

// //         rows.add(
// //           TableRow(
// //             children: [
// //               if (a == 0)
// //                 TableCell(
// //                   verticalAlignment: TableCellVerticalAlignment.fill,
// //                   child: Container(
// //                     color: moduleColors[m],
// //                     height: 60.0 * activitySpan,
// //                     padding: const EdgeInsets.all(8),
// //                     child: Center(
// //                       child: Text(
// //                         moduleTitles[m],
// //                         style: const TextStyle(
// //                           color: Colors.white,
// //                           fontWeight: FontWeight.bold,
// //                           fontSize: 14,
// //                         ),
// //                         textAlign: TextAlign.center,
// //                       ),
// //                     ),
// //                   ),
// //                 )
// //               else
// //                 const SizedBox.shrink(),
// //               Padding(
// //                 padding: const EdgeInsets.all(12),
// //                 child: Text(activities[a], style: const TextStyle(fontSize: 14)),
// //               ),
// //               Padding(
// //                 padding: const EdgeInsets.all(12),
// //                 child: Text(progressText, style: const TextStyle(fontSize: 14)),
// //               ),
// //             ],
// //           ),
// //         );
// //       }
// //     }

// //     return rows;
// //   }

// //   void exportAsCSV() {
// //     List<List<String>> csvData = [
// //       ['Module', 'Activity', 'Score'],
// //     ];

// //     for (int m = 0; m < moduleTitles.length; m++) {
// //       for (int a = 0; a < activityNames[m].length; a++) {
// //         String key = 'lesson_score_module${m}_lesson$a';
// //         String score = scores[key] ?? '-';
// //         csvData.add([moduleTitles[m], activityNames[m][a], score]);
// //       }
// //     }

// //     final csv = const ListToCsvConverter().convert(csvData);
// //     Printing.sharePdf(bytes: Uint8List.fromList(csv.codeUnits), filename: 'progress_report.csv');
// //   }

// //   void exportAsPDF() async {
// //     final pdf = pw.Document();

// //     pdf.addPage(
// //       pw.Page(
// //         build: (pw.Context context) {
// //           return pw.Column(
// //             children: [
// //               pw.Text('EduBot Progress Report', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
// //               pw.SizedBox(height: 10),
// //               pw.Text("Last Updated: $lastUpdated"),
// //               pw.SizedBox(height: 10),
// //               pw.Table.fromTextArray(
// //                 headers: ['Module', 'Activity', 'Score'],
// //                 data: [
// //                   for (int m = 0; m < moduleTitles.length; m++)
// //                     for (int a = 0; a < activityNames[m].length; a++)
// //                       [
// //                         moduleTitles[m],
// //                         activityNames[m][a],
// //                         scores['lesson_score_module${m}_lesson$a'] ?? '-',
// //                       ]
// //                 ],
// //               ),
// //             ],
// //           );
// //         },
// //       ),
// //     );

// //     await Printing.layoutPdf(onLayout: (format) => pdf.save());
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_core/firebase_core.dart';
// import 'package:intl/intl.dart';
// import 'dart:typed_data';
// import 'package:csv/csv.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// class ProgressReportScreen extends StatefulWidget {
//   const ProgressReportScreen({super.key});

//   @override
//   State<ProgressReportScreen> createState() => _ProgressReportScreenState();
// }

// class _ProgressReportScreenState extends State<ProgressReportScreen> {
//   final List<String> moduleTitles = [
//     'Communication Skills',
//     'Cognitive Skills',
//     'Social Interaction',
//   ];

//   final List<Color> moduleColors = [
//     Colors.purple,
//     Colors.blue,
//     Colors.teal,
//   ];

//   final List<List<String>> activityNames = [
//     [
//       'Greetings and Introductions',
//       'Asking for Help',
//       'Expressing Needs',
//       'Expressing Emotions',
//       'Talking with Friends',
//     ],
//     [
//       'Learn Your Morning Routine',
//       'Going to School Routine',
//       'Back from School Routine',
//     ],
//     [
//       'Activity 1',
//       'Activity 2',
//       'Activity 3',
//     ],
//   ];

//   Map<String, String> scores = {};
//   String lastUpdated = '';
//   final String userId = 'hl2kH6Eex5MKVNY0luV9n7GrRTW2';

//   @override
//   void initState() {
//     super.initState();
//     loadScores();
//   }

//   Future<void> loadScores() async {
//     Map<String, String> loaded = {};

//     final snapshot = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(userId)
//         .collection('progress')
//         .get();

//     for (var doc in snapshot.docs) {
//       loaded[doc.id] = doc['score'] ?? '-';
//     }

//     setState(() {
//       scores = loaded;
//       lastUpdated = DateFormat('dd MMM yyyy – hh:mm a').format(DateTime.now());
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Progress Report")),
//       body: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Container(
//                 width: MediaQuery.of(context).size.width,
//                 padding: const EdgeInsets.all(12),
//                 child: Table(
//                   border: TableBorder.all(color: Colors.black),
//                   columnWidths: const {
//                     0: FixedColumnWidth(160),
//                     1: FlexColumnWidth(),
//                     2: FixedColumnWidth(110),
//                   },
//                   defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//                   children: _buildFullTableRows(),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           Text("Last Updated: $lastUpdated"),
//           const SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton.icon(
//                 onPressed: exportAsCSV,
//                 icon: const Icon(Icons.table_chart),
//                 label: const Text("Export CSV"),
//               ),
//               const SizedBox(width: 12),
//               ElevatedButton.icon(
//                 onPressed: exportAsPDF,
//                 icon: const Icon(Icons.picture_as_pdf),
//                 label: const Text("Export PDF"),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }

//   List<TableRow> _buildFullTableRows() {
//     List<TableRow> rows = [];

//     rows.add(
//       TableRow(
//         decoration: const BoxDecoration(color: Colors.grey),
//         children: const [
//           Padding(
//             padding: EdgeInsets.all(8),
//             child: Text('Modules', style: TextStyle(fontWeight: FontWeight.bold)),
//           ),
//           Padding(
//             padding: EdgeInsets.all(8),
//             child: Text('Activities', style: TextStyle(fontWeight: FontWeight.bold)),
//           ),
//           Padding(
//             padding: EdgeInsets.all(8),
//             child: Text('Score', style: TextStyle(fontWeight: FontWeight.bold)),
//           ),
//         ],
//       ),
//     );

//     for (int m = 0; m < moduleTitles.length; m++) {
//       final List<String> activities = activityNames[m];
//       final int activitySpan = activities.length;

//       for (int a = 0; a < activitySpan; a++) {
//         String key = 'module_${m}_lesson_$a';
//         String score = scores[key] ?? '-';

//         rows.add(
//           TableRow(
//             children: [
//               if (a == 0)
//                 TableCell(
//                   verticalAlignment: TableCellVerticalAlignment.fill,
//                   child: Container(
//                     color: moduleColors[m],
//                     height: 60.0 * activitySpan,
//                     padding: const EdgeInsets.all(8),
//                     child: Center(
//                       child: Text(
//                         moduleTitles[m],
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ),
//                 )
//               else
//                 const SizedBox.shrink(),
//               Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Text(activities[a], style: const TextStyle(fontSize: 14)),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Text(score, style: const TextStyle(fontSize: 14)),
//               ),
//             ],
//           ),
//         );
//       }
//     }

//     return rows;
//   }

//   void exportAsCSV() {
//     List<List<String>> csvData = [
//       ['Module', 'Activity', 'Score'],
//     ];

//     for (int m = 0; m < moduleTitles.length; m++) {
//       for (int a = 0; a < activityNames[m].length; a++) {
//         String key = 'module_${m}_lesson_$a';
//         String score = scores[key] ?? '-';
//         csvData.add([moduleTitles[m], activityNames[m][a], score]);
//       }
//     }

//     final csv = const ListToCsvConverter().convert(csvData);
//     Printing.sharePdf(bytes: Uint8List.fromList(csv.codeUnits), filename: 'progress_report.csv');
//   }

//   void exportAsPDF() async {
//     final pdf = pw.Document();

//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) {
//           return pw.Column(
//             children: [
//               pw.Text('EduBot Progress Report', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
//               pw.SizedBox(height: 10),
//               pw.Text("Last Updated: $lastUpdated"),
//               pw.SizedBox(height: 10),
//               pw.Table.fromTextArray(
//                 headers: ['Module', 'Activity', 'Score'],
//                 data: [
//                   for (int m = 0; m < moduleTitles.length; m++)
//                     for (int a = 0; a < activityNames[m].length; a++)
//                       [
//                         moduleTitles[m],
//                         activityNames[m][a],
//                         scores['module_${m}_lesson_$a'] ?? '-',
//                       ]
//                 ],
//               ),
//             ],
//           );
//         },
//       ),
//     );

//     await Printing.layoutPdf(onLayout: (format) => pdf.save());
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:intl/intl.dart';
// import 'dart:typed_data';
// import 'package:csv/csv.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// class ProgressReportScreen extends StatefulWidget {
//   const ProgressReportScreen({super.key});

//   @override
//   State<ProgressReportScreen> createState() => _ProgressReportScreenState();
// }

// class _ProgressReportScreenState extends State<ProgressReportScreen> {
//   final List<String> moduleTitles = [
//     'Communication Skills',
//     'Cognitive Skills',
//     'Social Interaction',
//   ];

//   final List<Color> moduleColors = [
//     Colors.purple,
//     Colors.blue,
//     Colors.teal,
//   ];

//   final List<List<String>> activityNames = [
//     [
//       'Greetings and Introductions',
//       'Asking for Help',
//       'Expressing Needs',
//       'Expressing Emotions',
//       'Talking with Friends',
//     ],
//     [
//       'Learn Your Morning Routine',
//       'Going to School Routine',
//       'Back from School Routine',
//     ],
//     [
//       'Activity 1',
//       'Activity 2',
//       'Activity 3',
//     ],
//   ];

//   Map<String, String> scores = {};
//   String lastUpdated = '';

//   @override
//   void initState() {
//     super.initState();
//     loadScores();
//   }

//   Future<void> loadScores() async {
//     Map<String, String> loaded = {};
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid == null) return;

//     final ref = FirebaseDatabase.instance.ref("users/$uid/progress");
//     final snapshot = await ref.get();
//     final data = snapshot.value as Map<dynamic, dynamic>?;

//     if (data != null) {
//       data.forEach((key, value) {
//         if (value is Map && value['score'] != null) {
//           loaded[key.toString()] = value['score'].toString();
//         }
//       });
//     }

//     setState(() {
//       scores = loaded;
//       lastUpdated = DateFormat('dd MMM yyyy – hh:mm a').format(DateTime.now());
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Progress Report")),
//       body: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Container(
//                 width: MediaQuery.of(context).size.width,
//                 padding: const EdgeInsets.all(12),
//                 child: Table(
//                   border: TableBorder.all(color: Colors.black),
//                   columnWidths: const {
//                     0: FixedColumnWidth(160),
//                     1: FlexColumnWidth(),
//                     2: FixedColumnWidth(110),
//                   },
//                   defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//                   children: _buildFullTableRows(),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           Text("Last Updated: $lastUpdated"),
//           const SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton.icon(
//                 onPressed: exportAsCSV,
//                 icon: const Icon(Icons.table_chart),
//                 label: const Text("Export CSV"),
//               ),
//               const SizedBox(width: 12),
//               ElevatedButton.icon(
//                 onPressed: exportAsPDF,
//                 icon: const Icon(Icons.picture_as_pdf),
//                 label: const Text("Export PDF"),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }

//   List<TableRow> _buildFullTableRows() {
//     List<TableRow> rows = [];

//     rows.add(
//       TableRow(
//         decoration: const BoxDecoration(color: Colors.grey),
//         children: const [
//           Padding(
//             padding: EdgeInsets.all(8),
//             child: Text('Modules', style: TextStyle(fontWeight: FontWeight.bold)),
//           ),
//           Padding(
//             padding: EdgeInsets.all(8),
//             child: Text('Activities', style: TextStyle(fontWeight: FontWeight.bold)),
//           ),
//           Padding(
//             padding: EdgeInsets.all(8),
//             child: Text('Score', style: TextStyle(fontWeight: FontWeight.bold)),
//           ),
//         ],
//       ),
//     );

//     for (int m = 0; m < moduleTitles.length; m++) {
//       final List<String> activities = activityNames[m];
//       final int activitySpan = activities.length;

//       for (int a = 0; a < activitySpan; a++) {
//         String key = 'module_${m}_lesson_$a';
//         String score = scores[key] ?? '-';

//         rows.add(
//           TableRow(
//             children: [
//               if (a == 0)
//                 TableCell(
//                   verticalAlignment: TableCellVerticalAlignment.fill,
//                   child: Container(
//                     color: moduleColors[m],
//                     height: 60.0 * activitySpan,
//                     padding: const EdgeInsets.all(8),
//                     child: Center(
//                       child: Text(
//                         moduleTitles[m],
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ),
//                 )
//               else
//                 const SizedBox.shrink(),
//               Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Text(activities[a], style: const TextStyle(fontSize: 14)),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Text(score, style: const TextStyle(fontSize: 14)),
//               ),
//             ],
//           ),
//         );
//       }
//     }

//     return rows;
//   }

//   void exportAsCSV() {
//     List<List<String>> csvData = [
//       ['Module', 'Activity', 'Score'],
//     ];

//     for (int m = 0; m < moduleTitles.length; m++) {
//       for (int a = 0; a < activityNames[m].length; a++) {
//         String key = 'module_${m}_lesson_$a';
//         String score = scores[key] ?? '-';
//         csvData.add([moduleTitles[m], activityNames[m][a], score]);
//       }
//     }

//     final csv = const ListToCsvConverter().convert(csvData);
//     Printing.sharePdf(bytes: Uint8List.fromList(csv.codeUnits), filename: 'progress_report.csv');
//   }

//   void exportAsPDF() async {
//     final pdf = pw.Document();

//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) {
//           return pw.Column(
//             children: [
//               pw.Text('EduBot Progress Report', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
//               pw.SizedBox(height: 10),
//               pw.Text("Last Updated: $lastUpdated"),
//               pw.SizedBox(height: 10),
//               pw.Table.fromTextArray(
//                 headers: ['Module', 'Activity', 'Score'],
//                 data: [
//                   for (int m = 0; m < moduleTitles.length; m++)
//                     for (int a = 0; a < activityNames[m].length; a++)
//                       [
//                         moduleTitles[m],
//                         activityNames[m][a],
//                         scores['module_${m}_lesson_$a'] ?? '-',
//                       ]
//                 ],
//               ),
//             ],
//           );
//         },
//       ),
//     );

//     await Printing.layoutPdf(onLayout: (format) => pdf.save());
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:intl/intl.dart';
// import 'dart:typed_data';
// import 'package:csv/csv.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// class ProgressReportScreen extends StatefulWidget {
//   const ProgressReportScreen({super.key});

//   @override
//   State<ProgressReportScreen> createState() => _ProgressReportScreenState();
// }

// class _ProgressReportScreenState extends State<ProgressReportScreen> {
//   final List<Map<String, dynamic>> skills = [
//     {'skill': 'Communication', 'progress': 60},
//     {'skill': 'Social Interaction', 'progress': 45},
//     {'skill': 'Fine Motor Skills', 'progress': 70},
//     {'skill': 'Sensory Processing', 'progress': 50},
//   ];

//   final List<Map<String, dynamic>> activities = [
//     {
//       'activity': 'Verbal Communication Practice',
//       'status': 'In Progress',
//       'scores': [80, 70, 90],
//     },
//     {
//       'activity': 'Group Play Session',
//       'status': 'Not Started',
//       'scores': [0, 0, 0],
//     },
//     {
//       'activity': 'Puzzle Assembly',
//       'status': 'Completed',
//       'scores': [85, 90, 95],
//     },
//     {
//       'activity': 'Sensory Play',
//       'status': 'In Progress',
//       'scores': [60, 65, 70],
//     },
//   ];

//   String lastUpdated = '';

//   @override
//   void initState() {
//     super.initState();
//     loadData();
//   }

//   Future<void> loadData() async {
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid == null) return;

//     final ref = FirebaseDatabase.instance.ref("users/$uid/progress");
//     final snapshot = await ref.get();
//     final data = snapshot.value as Map<dynamic, dynamic>?;

//     if (data != null) {
//       setState(() {
//         for (var activity in activities) {
//           final key = activity['activity'].replaceAll(' ', '_').toLowerCase();
//           if (data[key] != null) {
//             activity['status'] = data[key]['status'] ?? activity['status'];
//             activity['scores'] = List<int>.from(
//               data[key]['scores'] ?? activity['scores'],
//             );
//           }
//         }
//         lastUpdated = DateFormat(
//           'dd MMM yyyy – hh:mm a',
//         ).format(DateTime.now());
//       });
//     }
//   }

//   Future<void> saveData(
//     String activityName,
//     String status,
//     List<int> scores,
//   ) async {
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid == null) return;

//     final ref = FirebaseDatabase.instance.ref(
//       "users/$uid/progress/${activityName.replaceAll(' ', '_').toLowerCase()}",
//     );
//     await ref.set({'status': status, 'scores': scores});

//     // Update skill progress if activity is completed
//     if (status == 'Completed') {
//       setState(() {
//         for (var skill in skills) {
//           if (activityName.toLowerCase().contains(
//             skill['skill'].toLowerCase(),
//           )) {
//             skill['progress'] = (skill['progress'] + 10).clamp(0, 100);
//           }
//         }
//       });
//     }

//     setState(() {
//       lastUpdated = DateFormat('dd MMM yyyy – hh:mm a').format(DateTime.now());
//     });
//   }

//   void exportAsCSV() {
//     List<List<dynamic>> csvData = [
//       ['Skill', 'Progress (%)'],
//       ...skills.map((s) => [s['skill'], s['progress']]),
//       [],
//       ['Activity', 'Status', 'Task 1 Score', 'Task 2 Score', 'Task 3 Score'],
//       ...activities.map(
//         (a) => [
//           a['activity'],
//           a['status'],
//           a['scores'][0],
//           a['scores'][1],
//           a['scores'][2],
//         ],
//       ),
//     ];

//     final csv = const ListToCsvConverter().convert(csvData);
//     Printing.sharePdf(
//       bytes: Uint8List.fromList(csv.codeUnits),
//       filename: 'progress_report.csv',
//     );
//   }

//   void exportAsPDF() async {
//     final pdf = pw.Document();
//     final font = await PdfGoogleFonts.openSansRegular();

//     pdf.addPage(
//       pw.MultiPage(
//         build:
//             (pw.Context context) => [
//               pw.Text(
//                 'ASD Progress Report',
//                 style: pw.TextStyle(
//                   font: font,
//                   fontSize: 22,
//                   fontWeight: pw.FontWeight.bold,
//                 ),
//               ),
//               pw.SizedBox(height: 10),
//               pw.Text(
//                 'Last Updated: $lastUpdated',
//                 style: pw.TextStyle(font: font, fontSize: 12),
//               ),
//               pw.SizedBox(height: 10),
//               pw.Text(
//                 'Skills Progress',
//                 style: pw.TextStyle(
//                   font: font,
//                   fontSize: 16,
//                   fontWeight: pw.FontWeight.bold,
//                 ),
//               ),
//               pw.SizedBox(height: 5),
//               ...skills.map(
//                 (s) => pw.Padding(
//                   padding: const pw.EdgeInsets.only(bottom: 5),
//                   child: pw.Text(
//                     '${s['skill']}: ${s['progress']}%',
//                     style: pw.TextStyle(font: font, fontSize: 12),
//                   ),
//                 ),
//               ),
//               pw.SizedBox(height: 10),
//               pw.Text(
//                 'Activities',
//                 style: pw.TextStyle(
//                   font: font,
//                   fontSize: 16,
//                   fontWeight: pw.FontWeight.bold,
//                 ),
//               ),
//               pw.SizedBox(height: 5),
//               ...activities.map(
//                 (a) => pw.Column(
//                   crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   children: [
//                     pw.Text(
//                       '${a['activity']} - Status: ${a['status']}',
//                       style: pw.TextStyle(font: font, fontSize: 12),
//                     ),
//                     pw.Text(
//                       'Scores: Task 1: ${a['scores'][0]}, Task 2: ${a['scores'][1]}, Task 3: ${a['scores'][2]}',
//                       style: pw.TextStyle(font: font, fontSize: 12),
//                     ),
//                     pw.SizedBox(height: 10),
//                   ],
//                 ),
//               ),
//             ],
//       ),
//     );

//     await Printing.layoutPdf(onLayout: (format) => pdf.save());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('ASD Progress Report'),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Skill Progress',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             ...skills.map(
//               (skill) => Padding(
//                 padding: const EdgeInsets.only(bottom: 16),
//                 child: _ProgressBar(
//                   skill: skill['skill'],
//                   progress: skill['progress'],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               'Activities',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             ...activities.map(
//               (activity) => Padding(
//                 padding: const EdgeInsets.only(bottom: 16),
//                 child: _ActivityCard(
//                   activity: activity['activity'],
//                   status: activity['status'],
//                   scores: List<int>.from(activity['scores']),
//                   onStatusChange: (newStatus) {
//                     setState(() {
//                       activity['status'] = newStatus;
//                     });
//                     saveData(
//                       activity['activity'],
//                       newStatus,
//                       activity['scores'],
//                     );
//                   },
//                   onScoreChange: (index, value) {
//                     setState(() {
//                       activity['scores'][index] = value;
//                     });
//                     saveData(
//                       activity['activity'],
//                       activity['status'],
//                       activity['scores'],
//                     );
//                   },
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'Last Updated: $lastUpdated',
//               style: const TextStyle(fontSize: 14),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: exportAsCSV,
//                   icon: const Icon(Icons.table_chart),
//                   label: const Text('Download CSV'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                     foregroundColor: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 ElevatedButton.icon(
//                   onPressed: exportAsPDF,
//                   icon: const Icon(Icons.picture_as_pdf),
//                   label: const Text('Download PDF'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     foregroundColor: Colors.white,
//                   ),
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
//             Text(
//               skill,
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//             ),
//             Text(
//               '$progress%',
//               style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//             ),
//           ],
//         ),
//         const SizedBox(height: 4),
//         LinearProgressIndicator(
//           value: progress / 100,
//           backgroundColor: Colors.grey[300],
//           valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
//           minHeight: 8,
//           borderRadius: BorderRadius.circular(4),
//         ),
//       ],
//     );
//   }
// }

// class _ActivityCard extends StatelessWidget {
//   final String activity;
//   final String status;
//   final List<int> scores;
//   final ValueChanged<String> onStatusChange;
//   final void Function(int index, int value) onScoreChange;

//   const _ActivityCard({
//     required this.activity,
//     required this.status,
//     required this.scores,
//     required this.onStatusChange,
//     required this.onScoreChange,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         activity,
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       Text(
//                         'Status: $status',
//                         style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                       ),
//                     ],
//                   ),
//                 ),
//                 DropdownButton<String>(
//                   value: status,
//                   items:
//                       ['Not Started', 'In Progress', 'Completed']
//                           .map(
//                             (status) => DropdownMenuItem(
//                               value: status,
//                               child: Text(status),
//                             ),
//                           )
//                           .toList(),
//                   onChanged: (value) {
//                     if (value != null) {
//                       onStatusChange(value);
//                     }
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             const Text(
//               'Activity Scores',
//               style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: List.generate(
//                 3,
//                 (index) => Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 4),
//                     child: Column(
//                       children: [
//                         Text(
//                           'Task ${index + 1}',
//                           style: const TextStyle(fontSize: 12),
//                         ),
//                         TextFormField(
//                           initialValue: scores[index].toString(),
//                           keyboardType: TextInputType.number,
//                           decoration: const InputDecoration(
//                             border: OutlineInputBorder(),
//                             contentPadding: EdgeInsets.symmetric(
//                               horizontal: 8,
//                               vertical: 4,
//                             ),
//                           ),
//                           onChanged: (value) {
//                             final intValue = int.tryParse(value) ?? 0;
//                             onScoreChange(index, intValue.clamp(0, 100));
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// 

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'package:csv/csv.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ProgressReportScreen extends StatefulWidget {
  const ProgressReportScreen({super.key});

  @override
  State<ProgressReportScreen> createState() => _ProgressReportScreenState();
}

class _ProgressReportScreenState extends State<ProgressReportScreen> {
  final List<Map<String, dynamic>> skills = [
    {'skill': 'Behavioral', 'progress': 0},
    {'skill': 'Communicational', 'progress': 0},
    {'skill': 'Cognitive', 'progress': 0},
  ];

  final List<Map<String, dynamic>> activities = [
    {
      'activity': 'Verbal Communication Practice',
      'status': 'Not Started',
      'scores': [0, 0, 0],
      'skill': 'Communicational'
    },
    {
      'activity': 'Group Play Session',
      'status': 'Not Started',
      'scores': [0, 0, 0],
      'skill': 'Behavioral'
    },
    {
      'activity': 'Puzzle Assembly',
      'status': 'Not Started',
      'scores': [0, 0, 0],
      'skill': 'Cognitive'
    },
    {
      'activity': 'Sensory Play',
      'status': 'Not Started',
      'scores': [0, 0, 0],
      'skill': 'Behavioral'
    },
  ];

  String lastUpdated = '';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final ref = FirebaseDatabase.instance.ref("users/$uid/progress");
    final snapshot = await ref.get();
    final data = snapshot.value as Map<dynamic, dynamic>?;

    if (data != null) {
      setState(() {
        for (var activity in activities) {
          final key = activity['activity'].replaceAll(' ', '_').toLowerCase();
          if (data[key] != null) {
            activity['status'] = data[key]['status'] ?? 'Not Started';
            activity['scores'] = List<int>.from(data[key]['scores'] ?? [0, 0, 0]);
          }
        }

        // Calculate skill progress based on activity scores
        for (var skill in skills) {
          final relatedActivities = activities.where((a) => a['skill'] == skill['skill']).toList();
          if (relatedActivities.isNotEmpty) {
            final totalScores = relatedActivities
                .map((a) => a['scores'].reduce((a, b) => a + b) / a['scores'].length)
                .reduce((a, b) => a + b);
            skill['progress'] = (totalScores / relatedActivities.length).round();
          }
        }

        lastUpdated = DateFormat('dd MMM yyyy – hh:mm a').format(DateTime.now());
      });
    }
  }

  Future<void> saveData(String activityName, String status, List<int> scores, String skill) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final ref = FirebaseDatabase.instance
        .ref("users/$uid/progress/${activityName.replaceAll(' ', '_').toLowerCase()}");
    await ref.set({
      'status': status,
      'scores': scores,
      'skill': skill,
    });

    // Update skill progress
    setState(() {
      for (var s in skills) {
        final relatedActivities = activities.where((a) => a['skill'] == s['skill']).toList();
        if (relatedActivities.isNotEmpty) {
          final totalScores = relatedActivities
              .map((a) => a['scores'].reduce((a, b) => a + b) / a['scores'].length)
              .reduce((a, b) => a + b);
          s['progress'] = (totalScores / relatedActivities.length).round();
        }
      }

      lastUpdated = DateFormat('dd MMM yyyy – hh:mm a').format(DateTime.now());
    });
  }

  void exportAsCSV() {
    List<List<dynamic>> csvData = [
      ['Skill', 'Progress (%)'],
      ...skills.map((s) => [s['skill'], s['progress']]),
      [],
      ['Activity', 'Status', 'Task 1 Score', 'Task 2 Score', 'Task 3 Score', 'Related Skill'],
      ...activities.map((a) => [
            a['activity'],
            a['status'],
            a['scores'][0],
            a['scores'][1],
            a['scores'][2],
            a['skill'],
          ]),
    ];

    final csv = const ListToCsvConverter().convert(csvData);
    Printing.sharePdf(
      bytes: Uint8List.fromList(csv.codeUnits),
      filename: 'progress_report.csv',
    );
  }

  void exportAsPDF() async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.openSansRegular();

    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) => [
          pw.Text(
            'ASD Progress Report',
            style: pw.TextStyle(font: font, fontSize: 22, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Text('Last Updated: $lastUpdated', style: pw.TextStyle(font: font, fontSize: 12)),
          pw.SizedBox(height: 10),
          pw.Text('Skills Progress', style: pw.TextStyle(font: font, fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 5),
          ...skills.map((s) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 5),
                child: pw.Text('${s['skill']}: ${s['progress']}%',
                    style: pw.TextStyle(font: font, fontSize: 12)),
              )),
          pw.SizedBox(height: 10),
          pw.Text('Activities', style: pw.TextStyle(font: font, fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 5),
          ...activities.map((a) => pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('${a['activity']} - Status: ${a['status']} (Skill: ${a['skill']})',
                      style: pw.TextStyle(font: font, fontSize: 12)),
                  pw.Text(
                      'Scores: Task 1: ${a['scores'][0]}, Task 2: ${a['scores'][1]}, Task 3: ${a['scores'][2]}',
                      style: pw.TextStyle(font: font, fontSize: 12)),
                  pw.SizedBox(height: 10),
                ],
              )),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ASD Progress Report'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Skill Progress',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...skills.map((skill) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _ProgressBar(
                    skill: skill['skill'],
                    progress: skill['progress'],
                  ),
                )),
            const SizedBox(height: 24),
            const Text(
              'Activities',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...activities.map((activity) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _ActivityCard(
                    activity: activity['activity'],
                    status: activity['status'],
                    scores: List<int>.from(activity['scores']),
                    skill: activity['skill'],
                    onStatusChange: (newStatus) {
                      setState(() {
                        activity['status'] = newStatus;
                      });
                      saveData(activity['activity'], newStatus, activity['scores'], activity['skill']);
                    },
                    onScoreChange: (index, value) {
                      setState(() {
                        activity['scores'][index] = value;
                      });
                      saveData(activity['activity'], activity['status'], activity['scores'], activity['skill']);
                    },
                  ),
                )),
            const SizedBox(height: 16),
            Text('Last Updated: $lastUpdated', style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: exportAsCSV,
                  icon: const Icon(Icons.table_chart),
                  label: const Text('Download CSV'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: exportAsPDF,
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Download PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final String skill;
  final int progress;

  const _ProgressBar({required this.skill, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(skill, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            Text('$progress%', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress / 100,
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final String activity;
  final String status;
  final List<int> scores;
  final String skill;
  final ValueChanged<String> onStatusChange;
  final void Function(int index, int value) onScoreChange;

  const _ActivityCard({
    required this.activity,
    required this.status,
    required this.scores,
    required this.skill,
    required this.onStatusChange,
    required this.onScoreChange,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Status: $status (Skill: $skill)',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                DropdownButton<String>(
                  value: status,
                  items: ['Not Started', 'In Progress', 'Completed']
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      onStatusChange(value);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('Activity Scores', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Row(
              children: List.generate(3, (index) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: [
                      Text('Task ${index + 1}', style: const TextStyle(fontSize: 12)),
                      TextFormField(
                        initialValue: scores[index].toString(),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        ),
                        onChanged: (value) {
                          final intValue = int.tryParse(value) ?? 0;
                          onScoreChange(index, intValue.clamp(0, 100));
                        },
                      ),
                    ],
                  ),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}