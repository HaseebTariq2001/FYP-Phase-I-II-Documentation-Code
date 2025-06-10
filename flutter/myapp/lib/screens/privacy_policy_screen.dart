import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color.fromARGB(
          255,
          161,
          129,
          216,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            // SectionTitle('Effective Date: June 5, 2025'),

            SectionHeader('1. Information We Collect'),
            SectionText(
                '- Personal Information: Name, email, child’s age, and login credentials.\n'
                '- Child Development Data: Assessment results, progress tracking details, and learning preferences.\n'
                '- Media & Interactions: Uploaded images, audio recordings, and activity usage logs.\n'
                '- Device & Usage Data: Device info, app version, and usage stats.'),

            SectionHeader('2. How We Use Your Data'),
            SectionText(
                '- Personalize learning modules based on assessments.\n'
                '- Provide chatbot guidance for parents.\n'
                '- Track progress and generate reports.\n'
                '- Improve app functionality and user experience.'),

            SectionHeader('3. Data Sharing & Disclosure'),
            SectionText(
                '- We do NOT sell your data.\n'
                '- Shared only with your consent or trusted service providers like Firebase.'),

            SectionHeader('4. Data Storage & Security'),
            SectionText(
                '- Data stored securely.\n'
                '- Encrypted login and access controls are enforced.'),

            SectionHeader('5. Children\'s Privacy'),
            SectionText(
                '- We collect child data only with parental consent.\n'
                '- No personal info is collected or shared without permission.'),

            SectionHeader('6. Your Rights'),
            SectionText(
                '- You have the right to Access, review, and update your or your child’s information\n'
                '- You have the right to Access, update, or delete your data anytime.\n'
                '- You have the right to be informed about how your data is used and shared.'),

            SectionHeader('7. Changes to Policy'),
            SectionText(
                '- Policy updates will be notified via app or email.'),

            SectionHeader('8. Contact Us'),
            SectionText(
                '📧 70126012@student.uol.edu.pk\n'
                '📧 70126610@student.uol.edu.pk\n'
                '📧 70109359@student.uol.edu.pk\n'
                '📍 University Of Lahore'),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey));
  }
}

class SectionHeader extends StatelessWidget {
  final String text;
  const SectionHeader(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(text,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
    );
  }
}

class SectionText extends StatelessWidget {
  final String text;
  const SectionText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87));
  }
}
