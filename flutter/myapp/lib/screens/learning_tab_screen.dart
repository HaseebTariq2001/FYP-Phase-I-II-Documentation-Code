import 'package:flutter/material.dart';

class LearningTabScreen extends StatelessWidget {
  const LearningTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Educare"),
          bottom: TabBar(
            tabs: [
              Tab(text: "Learning Modules"),
              Tab(text: "Games"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Learning Modules
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildCard(
                    imagePath: 'assets/repeat_after_me.jpg',
                    title: "Communication Skills",
                    subtitle: "Part 2 • Level 1 - Level 5",
                    buttonText: "Join",
                    onPressed: () {
                      Navigator.pushNamed(context, '/courseDetail');
                    },
                  ),
                ],
              ),
            ),

            // Tab 2: Games and Activities
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildCard(
                    imagePath: 'assets/repeat_after_me.jpg',
                    title: "Communication Skills (Games and Activities)",
                    subtitle: "Part 2 • Level 1 - Level 5",
                    buttonText: "Play Games",
                    onPressed: () {
                      Navigator.pushNamed(context, '/activityDetail');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String imagePath,
    required String title,
    required String subtitle,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.asset(
              imagePath,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0, bottom: 12),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 183, 58, 177),
                  foregroundColor: Colors.white,
                  shape: StadiumBorder(),
                ),
                onPressed: onPressed,
                child: Text(buttonText),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
