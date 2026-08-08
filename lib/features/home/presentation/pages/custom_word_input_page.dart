import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../features/drawing/domain/entities/practice_mode.dart';
import '../../../../features/drawing/presentation/pages/drawing_page.dart';

class CustomWordInputPage extends StatefulWidget {
  const CustomWordInputPage({super.key});

  @override
  State<CustomWordInputPage> createState() => _CustomWordInputPageState();
}

class _CustomWordInputPageState extends State<CustomWordInputPage> {
  final TextEditingController _controller = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_validateInput);
  }

  void _validateInput() {
    final text = _controller.text.trim();
    if (text.isNotEmpty && !_isButtonEnabled) {
      setState(() {
        _isButtonEnabled = true;
      });
    } else if (text.isEmpty && _isButtonEnabled) {
      setState(() {
        _isButtonEnabled = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startTracing() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DrawingPage(
            practiceMode: PracticeMode.practiceCustomWords,
            customWords: [text],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFF9C4), // Soft Yellow
                Color(0xFFFFCDD2), // Soft Pink
                Color(0xFFE1BEE7), // Soft Purple
                Color(0xFFB3E5FC), // Soft Blue
              ],
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'Type & Trace',
              style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.w900,
                fontSize: 26,
                letterSpacing: 1.2,
              ),
            ),
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.deepPurple, size: 30),
          ),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.edit_note_rounded,
                      size: 80,
                      color: Colors.deepPurple,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Type any word you want to trace!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(25),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      child: TextField(
                        controller: _controller,
                        maxLength: 12,
                        textCapitalization: TextCapitalization.characters, // Default to uppercase typing
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.deepPurple,
                          letterSpacing: 2.0,
                        ),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: 'Type your word...',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.bold,
                          ),
                          counterText: '', // Hide the "0/12" counter for a cleaner look
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]')),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _isButtonEnabled ? _startTracing : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade300,
                        disabledForegroundColor: Colors.grey.shade500,
                        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: _isButtonEnabled ? 4 : 0,
                      ),
                      child: const Text(
                        'Start Tracing',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
