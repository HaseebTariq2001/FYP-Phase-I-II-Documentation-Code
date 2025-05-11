import 'package:flutter/material.dart';

class ProgressReportScreen extends StatefulWidget {
  final List<Map<String, String>> progressData;

  const ProgressReportScreen({Key? key, required this.progressData})
      : super(key: key);

  @override
  State<ProgressReportScreen> createState() => _ProgressReportScreenState();
}

class _ProgressReportScreenState extends State<ProgressReportScreen> {
  List<Map<String, String>> get progressData => widget.progressData;

  // Show confirmation dialog before clearing data
  void _confirmClearResults() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Clear Results'),
        content: Text('Are you sure you want to clear the results?'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                widget.progressData.clear();
              });
              Navigator.pop(context);
            },
            child: Text('Yes'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Progress Report'),
        backgroundColor: const Color.fromARGB(255, 161, 129, 216),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: progressData.isEmpty
            ? Center(
                child: Text(
                  'No progress data available.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: progressData.length,
                      itemBuilder: (context, index) {
                        final progress = progressData[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(
                              'Module: ${progress['moduleName']}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Date: ${progress['date']}'),
                                Text('Time: ${progress['time']}'),
                                Text('Correct Steps: ${progress['correctSteps']} out of 6'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _confirmClearResults,
                    icon: Icon(Icons.delete),
                    label: Text('Clear Results'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
