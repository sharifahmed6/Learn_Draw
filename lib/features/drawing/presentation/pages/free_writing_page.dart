import 'package:flutter/material.dart';
import '../../../../core/services/notification_service.dart';

class FreeWritingPage extends StatefulWidget {
  const FreeWritingPage({super.key});

  @override
  State<FreeWritingPage> createState() => _FreeWritingPageState();
}

class _FreeWritingPageState extends State<FreeWritingPage> {
  final List<DrawnStroke> _strokes = [];
  Color _selectedColor = Colors.deepPurple;
  bool _isEraserMode = false;
  bool _showRuledLines = true; // Added state for toggling lines
  final double _strokeWidth = 6.0;

  final List<Color> _colors = [
    Colors.deepPurple,
    Colors.redAccent,
    Colors.blueAccent,
    Colors.green,
    Colors.orange,
    Colors.black87,
  ];

  @override
  void initState() {
    super.initState();
    // Schedule notification 24 hours from session start
    NotificationService().scheduleNextPracticeReminder();
  }

  void _clearCanvas() {
    setState(() {
      _strokes.clear();
    });
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
              'Free Writing',
              style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.w900,
                fontSize: 26,
                letterSpacing: 1.2,
              ),
            ),
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.deepPurple, size: 30),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded, size: 30, color: Colors.deepPurple),
                onPressed: _clearCanvas,
                tooltip: 'Clear Canvas',
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                // Toggle Buttons for Notebook vs Blank
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => setState(() => _showRuledLines = true),
                        icon: const Icon(Icons.menu_book_rounded),
                        label: const Text('Notebook', style: TextStyle(fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _showRuledLines ? Colors.deepPurple : Colors.white,
                          foregroundColor: _showRuledLines ? Colors.white : Colors.deepPurple,
                          elevation: _showRuledLines ? 4 : 1,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: () => setState(() => _showRuledLines = false),
                        icon: const Icon(Icons.crop_din_rounded),
                        label: const Text('Blank', style: TextStyle(fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: !_showRuledLines ? Colors.deepPurple : Colors.white,
                          foregroundColor: !_showRuledLines ? Colors.white : Colors.deepPurple,
                          elevation: !_showRuledLines ? 4 : 1,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                    ],
                  ),
                ),
                // Drawing Area
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque, // Fixes drawing on blank screen
                          onPanStart: (details) {
                            setState(() {
                              _strokes.add(DrawnStroke(
                                points: [details.localPosition],
                                color: _selectedColor,
                                width: _isEraserMode ? 30.0 : _strokeWidth, // Eraser is thicker
                                isEraser: _isEraserMode,
                              ));
                            });
                          },
                          onPanUpdate: (details) {
                            setState(() {
                              if (_strokes.isNotEmpty) {
                                _strokes.last.points.add(details.localPosition);
                              }
                            });
                          },
                          onPanEnd: (details) {
                            // Stroke finished, nothing special needed unless we want to normalize
                          },
                          child: CustomPaint(
                            size: Size.infinite,
                            painter: _showRuledLines ? RuledLinesPainter() : null,
                            foregroundPainter: FreeWritingPainter(strokes: _strokes),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Color Toolbar
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _colors.map((color) {
                              bool isSelected = !_isEraserMode && _selectedColor == color;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isEraserMode = false;
                                    _selectedColor = color;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected ? Colors.white : Colors.transparent,
                                      width: 3,
                                    ),
                                    boxShadow: [
                                      if (isSelected)
                                        BoxShadow(
                                          color: color.withAlpha(100),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                        )
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      // Divider
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        width: 2,
                        height: 40,
                        color: Colors.grey.withAlpha(100),
                      ),
                      // Eraser
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isEraserMode = true;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _isEraserMode ? Colors.deepPurple : Colors.grey.withAlpha(100),
                              width: _isEraserMode ? 3 : 1,
                            ),
                            boxShadow: [
                              if (_isEraserMode)
                                BoxShadow(
                                  color: Colors.deepPurple.withAlpha(100),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                )
                            ],
                          ),
                          child: Icon(
                            Icons.cleaning_services_rounded,
                            color: _isEraserMode ? Colors.deepPurple : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DrawnStroke {
  final List<Offset> points;
  final Color color;
  final double width;
  final bool isEraser;

  DrawnStroke({
    required this.points,
    required this.color,
    required this.width,
    this.isEraser = false,
  });
}

class RuledLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // English Copybook has 4 lines in a group: Red, Blue, Blue, Red.
    final Paint topBottomPaint = Paint()
      ..color = Colors.red.withAlpha(150)
      ..strokeWidth = 2.0;

    final Paint middlePaint = Paint()
      ..color = Colors.blue.withAlpha(150)
      ..strokeWidth = 2.0;

    // We will draw these line groups repeatedly
    const double lineSpacing = 30.0;
    const double groupSpacing = 40.0;
    const double totalGroupHeight = (3 * lineSpacing) + groupSpacing;

    double y = 40.0; // Initial top padding

    while (y < size.height) {
      // Top line (Red)
      canvas.drawLine(Offset(0, y), Offset(size.width, y), topBottomPaint);
      
      // Upper middle line (Blue)
      canvas.drawLine(Offset(0, y + lineSpacing), Offset(size.width, y + lineSpacing), middlePaint);
      
      // Lower middle line (Blue)
      canvas.drawLine(Offset(0, y + 2 * lineSpacing), Offset(size.width, y + 2 * lineSpacing), middlePaint);
      
      // Bottom line (Red)
      canvas.drawLine(Offset(0, y + 3 * lineSpacing), Offset(size.width, y + 3 * lineSpacing), topBottomPaint);

      y += totalGroupHeight;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // Background lines don't change
  }
}

class FreeWritingPainter extends CustomPainter {
  final List<DrawnStroke> strokes;

  FreeWritingPainter({required this.strokes});

  @override
  void paint(Canvas canvas, Size size) {
    // Save layer to allow BlendMode.clear to erase only the drawn strokes,
    // leaving the ruled lines background intact.
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

    for (final stroke in strokes) {
      if (stroke.points.isEmpty) continue;

      final paint = Paint()
        ..color = stroke.isEraser ? Colors.transparent : stroke.color
        ..strokeWidth = stroke.width
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      if (stroke.isEraser) {
        paint.blendMode = BlendMode.clear;
      }

      final path = Path();
      path.moveTo(stroke.points.first.dx, stroke.points.first.dy);

      for (int i = 1; i < stroke.points.length; i++) {
        path.lineTo(stroke.points[i].dx, stroke.points[i].dy);
      }

      canvas.drawPath(path, paint);
    }
    
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant FreeWritingPainter oldDelegate) {
    return true; // Always repaint when strokes update
  }
}
