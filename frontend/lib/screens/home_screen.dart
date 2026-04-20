import 'package:flutter/material.dart';
import 'time_table_screen.dart';
import 'summarizer_screen.dart';
import 'code_help_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              const Text(
                'Welcome to Acad Helper',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(height: 30),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.2,
                  children: [
                    _buildNavCard(
                      context,
                      'TIME-TABLE',
                      Icons.access_time,
                      const Color(0xFF00A896),
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TimeTableScreen()),
                      ),
                    ),
                    _buildNavCard(
                      context,
                      'AI-SUMMARIZER',
                      Icons.description,
                      const Color(0xFF00A896),
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SummarizerScreen()),
                      ),
                    ),
                    _buildNavCard(
                      context,
                      'AI-CODE HELP',
                      Icons.code,
                      const Color(0xFF00A896),
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CodeHelpScreen()),
                      ),
                    ),
                    _buildNavCard(
                      context,
                      'ASSIGNMENTS',
                      Icons.assignment,
                      const Color(0xFF00A896),
                      () {}, // Skipping as per user request
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              
              _buildSectionCard(
                title: 'Write about yourself !!!!',
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B263B),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white12),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: const TextField(
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: "Share your thoughts, goals, and what you're working on...",
                      hintStyle: TextStyle(color: Colors.white38),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: Colors.white, fontFamily: 'monospace'),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              _buildSectionCard(
                title: 'Scenery of The Day',
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        'https://picsum.photos/seed/scenery/800/400',
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B263B),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white12),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: "Describe the most beautiful thing you saw today...",
                          hintStyle: TextStyle(color: Colors.white38, fontSize: 14),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF1B263B).withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }
}
