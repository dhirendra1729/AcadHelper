import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';
import '../services/api_service.dart';
import '../models/response_model.dart';

class SummarizerScreen extends StatefulWidget {
  const SummarizerScreen({super.key});

  @override
  State<SummarizerScreen> createState() => _SummarizerScreenState();
}

class _SummarizerScreenState extends State<SummarizerScreen> {
  bool _isProcessing = false;
  ResponseModel? _result;
  final ApiService _apiService = ApiService();
  final TextRecognizer _textRecognizer = TextRecognizer();

  @override
  void dispose() {
    _textRecognizer.close();
    super.dispose();
  }

  Future<void> _pickImage(bool fromCamera) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null && (result.files.single.bytes != null || result.files.single.path != null)) {
      _processImage(result.files.single.bytes, result.files.single.path);
    }
  }

  Future<void> _processImage(Uint8List? bytes, String? path) async {
    setState(() {
      _isProcessing = true;
      _result = null;
    });

    try {
      File imageFile;
      if (path != null) {
        imageFile = File(path);
      } else if (bytes != null) {
        final tempDir = await getTemporaryDirectory();
        imageFile = File('${tempDir.path}/temp_image.png');
        await imageFile.writeAsBytes(bytes);
      } else {
        return;
      }

      final inputImage = InputImage.fromFile(imageFile);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
      
      String extractedText = recognizedText.text;
      if (extractedText.isEmpty) {
        extractedText = "No text found in the document.";
      }

      final summary = await _apiService.summarizeText(extractedText);

      setState(() {
        _result = _apiService.generateResult(extractedText, summary ?? "Failed to generate summary.");
      });

      if (_result != null) {
        _showResultDialog(_result!);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _showResultDialog(ResponseModel result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1B263B),
        title: const Text("AI Summary", style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Extracted Text:", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
              Text(result.text, style: const TextStyle(color: Colors.white60, fontSize: 12)),
              const SizedBox(height: 20),
              const Text("Summary:", style: TextStyle(color: Color(0xFF00A896), fontWeight: FontWeight.bold)),
              Text(result.summary, style: const TextStyle(color: Colors.white, fontSize: 14)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CLOSE", style: TextStyle(color: Color(0xFFE94560))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'AI-SUMMARIZER',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B263B),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Upload or Capture Image",
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionBox(
                            icon: Icons.upload,
                            label: "Upload File",
                            subLabel: "Click to browse files",
                            onTap: () => _pickImage(false),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildActionBox(
                            icon: Icons.camera_alt,
                            label: "Take Photo",
                            subLabel: "Use your camera",
                            onTap: () => _pickImage(true),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(color: Colors.white54, fontSize: 13, height: 1.5),
                          children: [
                            TextSpan(
                              text: "Tip: ",
                              style: TextStyle(color: Color(0xFF00A896), fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: "For best results, ensure the image is clear and well-lit. The AI will scan and extract text, then provide a concise summary.",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              if (_isProcessing)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        CircularProgressIndicator(color: Color(0xFF00A896)),
                        SizedBox(height: 16),
                        Text("AI is working...", style: TextStyle(color: Colors.white54)),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 10),

              // How it works section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B263B).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.auto_awesome_mosaic, color: Color(0xFF00ADB5), size: 20),
                        SizedBox(width: 8),
                        Text(
                          "How it works:",
                          style: TextStyle(color: Color(0xFF00ADB5), fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildStepItem("Upload an image or take a photo of text documents"),
                    _buildStepItem("AI scans and extracts text using OCR technology"),
                    _buildStepItem("Automatically summarizes the content for easy reading"),
                    _buildStepItem("Perfect for lecture notes, textbooks, and handwritten documents"),
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

  Widget _buildActionBox({required IconData icon, required String label, required String subLabel, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF00A896).withOpacity(0.5), style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withOpacity(0.02),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF00A896), size: 36),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 4),
            Text(subLabel, style: const TextStyle(color: Colors.white38, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildStepItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(color: Colors.white54, fontSize: 18)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
