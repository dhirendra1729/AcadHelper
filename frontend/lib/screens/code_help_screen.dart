import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CodeHelpScreen extends StatefulWidget {
  const CodeHelpScreen({super.key});

  @override
  State<CodeHelpScreen> createState() => _CodeHelpScreenState();
}

class _CodeHelpScreenState extends State<CodeHelpScreen> {
  final TextEditingController _questionController = TextEditingController();
  final ApiService _apiService = ApiService();
  String _selectedLanguage = 'JavaScript';
  String? _aiResponse;
  bool _isLoading = false;

  final List<String> _languages = [
    'JavaScript',
    'Python',
    'Java',
    'C++',
    'Dart',
    'HTML/CSS',
    'SQL',
  ];

  final List<String> _quickQuestions = [
    'How to create function',
    'Explain loops',
    'Error handling',
  ];

  Future<void> _askQuestion(String question) async {
    if (question.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _aiResponse = null;
    });

    final prompt = "As a coding expert in $_selectedLanguage, answer this question clearly and provide code examples if applicable:\n\n$question";
    
    try {
      final response = await _apiService.summarizeText(prompt);
      setState(() {
        _aiResponse = response;
      });
    } catch (e) {
      setState(() {
        _aiResponse = "Error: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'AI-CODE HELP',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text('BACK TO HOME'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB5179E),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          Container(
            width: 250,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1B263B).withOpacity(0.5),
              border: const Border(right: BorderSide(color: Colors.white10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.code, color: Color(0xFF00ADB5), size: 18),
                    SizedBox(width: 8),
                    Text(
                      "Language",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D1B2A),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedLanguage,
                      dropdownColor: const Color(0xFF1B263B),
                      style: const TextStyle(color: Colors.white),
                      items: _languages.map((lang) {
                        return DropdownMenuItem(value: lang, child: Text(lang));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedLanguage = val);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00ADB5).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF00ADB5).withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Selected:",
                        style: TextStyle(color: Color(0xFF00ADB5), fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      Text(
                        _selectedLanguage,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  "Quick Questions:",
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 12),
                ..._quickQuestions.map((q) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        _questionController.text = q;
                        _askQuestion(q);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white70,
                        side: const BorderSide(color: Colors.white12),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        alignment: Alignment.centerLeft,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(q, style: const TextStyle(fontSize: 12)),
                    ),
                  ),
                )),
              ],
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ask Your Coding Question",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF1B263B),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: TextField(
                            controller: _questionController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Ask anything about $_selectedLanguage...",
                              hintStyle: const TextStyle(color: Colors.white38),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              border: InputBorder.none,
                            ),
                            onSubmitted: _askQuestion,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: _isLoading ? null : () => _askQuestion(_questionController.text),
                        icon: const Icon(Icons.send, size: 18),
                        label: const Text("Ask"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00ADB5),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Press Enter to send • Examples: \"How do I sort an array?\", \"Explain async/await\", \"Debug this error\"",
                    style: TextStyle(color: Colors.white38, fontSize: 11),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "AI Response",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B263B),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator(color: Color(0xFF00ADB5)))
                          : _aiResponse == null
                              ? const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.code, size: 64, color: Colors.white12),
                                      SizedBox(height: 16),
                                      Text(
                                        "Ask a coding question to get started",
                                        style: TextStyle(color: Colors.white24, fontSize: 16),
                                      ),
                                      Text(
                                        "Get help with debugging, syntax, best practices, and more",
                                        style: TextStyle(color: Colors.white12, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                )
                              : SingleChildScrollView(
                                  padding: const EdgeInsets.all(20),
                                  child: SelectableText(
                                    _aiResponse!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'monospace',
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00ADB5).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Tips for better answers:",
                          style: TextStyle(color: Color(0xFF00ADB5), fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        _buildTip("Be specific about what you're trying to achieve"),
                        _buildTip("Mention any error messages you're seeing"),
                        _buildTip("Include a small code snippet if relevant"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          const Text("• ", style: TextStyle(color: Colors.white38)),
          Text(text, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        ],
      ),
    );
  }
}
