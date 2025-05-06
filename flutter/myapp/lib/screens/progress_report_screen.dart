import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final List<String> moduleTitles = [
    'Communication Skills',
    'Cognitive Skills',
    'Social Interaction',
  ];

  final List<Color> moduleColors = [
    Colors.purple,
    Colors.blue,
    Colors.teal,
  ];

  final List<List<String>> activityNames = [
    [
      'Greetings and Introductions',
      'Asking for Help',
      'Expressing Needs',
      'Expressing Emotions',
      'Talking with Friends',
    ],
    [
      'Learn Your Morning Routine',
      'Going to School Routine',
      'Back from School Routine',
    ],
    [
      'Activity 1',
      'Activity 2',
      'Activity 3',
    ],
  ];

  Map<String, String> scores = {};
  String lastUpdated = '';

  @override
  void initState() {
    super.initState();
    loadScores();
  }

  Future<void> loadScores() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, String> loaded = {};

    for (int m = 0; m < moduleTitles.length; m++) {
      for (int a = 0; a < activityNames[m].length; a++) {
        String key = 'lesson_score_module${m}_lesson$a';
        loaded[key] = prefs.getString(key) ?? '-';
      }
    }

    setState(() {
      scores = loaded;
      lastUpdated = DateFormat('dd MMM yyyy – hh:mm a').format(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Progress Report")),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(12),
                child: Table(
                  border: TableBorder.all(color: Colors.black),
                  columnWidths: const {
                    0: FixedColumnWidth(160),
                    1: FlexColumnWidth(),
                    2: FixedColumnWidth(110),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: _buildFullTableRows(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text("Last Updated: $lastUpdated"),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: exportAsCSV,
                icon: const Icon(Icons.table_chart),
                label: const Text("Export CSV"),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: exportAsPDF,
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text("Export PDF"),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  List<TableRow> _buildFullTableRows() {
    List<TableRow> rows = [];

    rows.add(
      TableRow(
        decoration: const BoxDecoration(color: Colors.grey),
        children: const [
          Padding(
            padding: EdgeInsets.all(8),
            child: Text('Modules', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Text('Activities', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Text('Score (%)', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    for (int m = 0; m < moduleTitles.length; m++) {
      final List<String> activities = activityNames[m];
      final int activitySpan = activities.length;

      for (int a = 0; a < activitySpan; a++) {
        String key = 'lesson_score_module${m}_lesson$a';
        String score = scores[key] ?? '-';

        String progressText = score;
        String symbol = '';
        if (score.contains('/')) {
          final parts = score.split('/');
          final num = int.tryParse(parts[0]) ?? 0;
          final total = int.tryParse(parts[1]) ?? 1;
          final percent = ((num / total) * 100).toStringAsFixed(0);
          symbol = (num / total) >= 0.9 ? ' ✅' : ' ❌';
          progressText = "$score ($percent%)$symbol";
        }

        rows.add(
          TableRow(
            children: [
              if (a == 0)
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.fill,
                  child: Container(
                    color: moduleColors[m],
                    height: 60.0 * activitySpan,
                    padding: const EdgeInsets.all(8),
                    child: Center(
                      child: Text(
                        moduleTitles[m],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              else
                const SizedBox.shrink(),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(activities[a], style: const TextStyle(fontSize: 14)),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(progressText, style: const TextStyle(fontSize: 14)),
              ),
            ],
          ),
        );
      }
    }

    return rows;
  }

  void exportAsCSV() {
    List<List<String>> csvData = [
      ['Module', 'Activity', 'Score'],
    ];

    for (int m = 0; m < moduleTitles.length; m++) {
      for (int a = 0; a < activityNames[m].length; a++) {
        String key = 'lesson_score_module${m}_lesson$a';
        String score = scores[key] ?? '-';
        csvData.add([moduleTitles[m], activityNames[m][a], score]);
      }
    }

    final csv = const ListToCsvConverter().convert(csvData);
    Printing.sharePdf(bytes: Uint8List.fromList(csv.codeUnits), filename: 'progress_report.csv');
  }

  void exportAsPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('EduBot Progress Report', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text("Last Updated: $lastUpdated"),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headers: ['Module', 'Activity', 'Score'],
                data: [
                  for (int m = 0; m < moduleTitles.length; m++)
                    for (int a = 0; a < activityNames[m].length; a++)
                      [
                        moduleTitles[m],
                        activityNames[m][a],
                        scores['lesson_score_module${m}_lesson$a'] ?? '-',
                      ]
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }
}