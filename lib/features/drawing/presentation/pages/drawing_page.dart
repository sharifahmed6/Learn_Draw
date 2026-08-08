import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../progress/presentation/bloc/progress_bloc.dart';
import '../../../progress/presentation/bloc/progress_event.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:text_drawing_animation/text_drawing_animation.dart';
import '../../bloc/drawing_bloc.dart';
import '../../bloc/drawing_event.dart';
import '../../bloc/drawing_state.dart';
import '../../domain/entities/practice_mode.dart';
import '../../domain/entities/practice_item.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/utils/premium_manager.dart';
import '../../../subscription/presentation/pages/subscription_page.dart';

final FlutterTts _flutterTts = FlutterTts();

Future<void> _speakLetter(String text) async {
  await _flutterTts.setLanguage("en-US");
  await _flutterTts.setSpeechRate(0.4); // Standard rate
  await _flutterTts.setPitch(1.2); 
  // Speak the word directly instead of splitting by letter
  await _flutterTts.speak(text);
}

class DrawingPage extends StatelessWidget {
  final PracticeMode practiceMode;
  final List<String>? customWords;
  final List<PracticeItem>? customItems;
  final int initialIndex;

  const DrawingPage({
    super.key,
    required this.practiceMode,
    this.customWords,
    this.customItems,
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        // When user starts a practice session, schedule next reminder 24h from now
        NotificationService().scheduleNextPracticeReminder();

        List<String>? initialWords = customWords;
        // If it's a word practice mode and no custom words provided, use the 7-day filtered words
        if (initialWords == null && 
            (practiceMode == PracticeMode.practiceWords || 
             practiceMode == PracticeMode.learnWordsSimple || 
             practiceMode == PracticeMode.learnWordsCursive)) {
          final progressState = context.read<ProgressBloc>().state;
          if (progressState.availableWords.isNotEmpty) {
            // Shuffle and pick 10 words
            final words = List<String>.from(progressState.availableWords)..shuffle();
            initialWords = words.take(10).toList();
          }
        }
        return DrawingBloc(practiceMode, customWords: initialWords, customItems: customItems, initialIndex: initialIndex);
      },
      child: MultiBlocListener(
        listeners: [
          BlocListener<DrawingBloc, DrawingState>(
            listenWhen: (previous, current) {
              // Trigger SaveContinueLearningEvent when navigating to a new item
              return previous.currentIndex != current.currentIndex;
            },
            listener: (context, state) {
              if (state.items.isNotEmpty && state.currentIndex < state.items.length) {
                final nextItem = state.items[state.currentIndex];
                final title = practiceMode.name; // Can be mapped to a better title
                
                context.read<ProgressBloc>().add(SaveContinueLearningEvent(
                  practiceMode: practiceMode.toString(),
                  title: title,
                  nextItemId: nextItem.text,
                  currentIndex: state.currentIndex,
                  totalCount: state.items.length,
                  customWords: customWords,
                ));
              }
            },
          ),
          BlocListener<DrawingBloc, DrawingState>(
            listenWhen: (previous, current) {
              // Trigger dialog only when transitioning to completed state on the last letter
              return !previous.isCompleted && current.isCompleted && current.currentIndex == current.items.length - 1;
            },
            listener: (context, state) {
              // Save practice result
          if (state.items.isNotEmpty) {
            final word = state.items.map((e) => e.text).join(', ');
            context.read<ProgressBloc>().add(SavePracticeResultEvent(
              itemId: word,
              category: practiceMode.name,
              practiceType: 'tracing',
              score: 100, // Placeholder score
              durationSeconds: 30, // Placeholder duration
            ));
            
            if (practiceMode == PracticeMode.dailyChallenge) {
              context.read<ProgressBloc>().add(CompleteCurriculumDayEvent());
            }
          }

          Future.delayed(const Duration(milliseconds: 1500), () {
            if (!context.mounted) return;
            showDialog(
            context: context,
            barrierDismissible: false, // User must press a button to close
            builder: (BuildContext dialogContext) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                elevation: 10,
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.emoji_events_rounded,
                        color: Colors.amber,
                        size: 80,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Amazing Job!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'You finished all letters perfectly!',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        ),
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                        child: const Text(
                          'Awesome!',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
          }); // Close Future.delayed
        },
      ),
      ],
      child: BlocBuilder<DrawingBloc, DrawingState>(
          builder: (context, state) {
          return PopScope(
            canPop: true,
            onPopInvokedWithResult: (didPop, result) {
              _flutterTts.stop();
            },
            child: Stack(
              children: [
                // Beautiful Kid-Friendly Background Gradient
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
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        _flutterTts.stop();
                        Navigator.of(context).pop();
                      },
                    ),
                    title: const Text(
                      'Magic Drawing',
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
                  child: Builder(
                    builder: (context) {
                      if (state.items.isEmpty) return const Center(child: CircularProgressIndicator());

                      final currentItem = state.items[state.currentIndex];

                      return OrientationBuilder(
                        builder: (context, orientation) {
                          bool isLandscape = orientation == Orientation.landscape;

                          return Padding(
                            padding: isLandscape 
                                ? EdgeInsets.zero 
                                : const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Flex(
                              direction: isLandscape ? Axis.horizontal : Axis.vertical,
                              children: [
                                // Portrait mode: Text at the top
                                if (!isLandscape)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      '${state.currentIndex + 1} of ${state.items.length}',
                                      style: const TextStyle(
                                        fontSize: 22, 
                                        fontWeight: FontWeight.w900, 
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                  ),
                                
                                // Drawing Area (Preserved across rotation using a unique Key)
                                Expanded(
                                  key: const ValueKey('drawing_area_container'),
                                  child: Padding(
                                    padding: isLandscape ? const EdgeInsets.all(8.0) : EdgeInsets.zero,
                                    child: _buildAnimatedContainer(context, state, currentItem),
                                  ),
                                ),

                                // Controls
                                if (isLandscape)
                                  Container(
                                    width: 150,
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${state.currentIndex + 1}/${state.items.length}',
                                          style: const TextStyle(
                                            fontSize: 20, 
                                            fontWeight: FontWeight.w900, 
                                            color: Colors.deepPurple,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        _buildPrevButton(context, state),
                                        const SizedBox(height: 8),
                                        _buildReplayButton(context, state),
                                        const SizedBox(height: 8),
                                        _buildNextButton(context, state),
                                      ],
                                    ),
                                  )
                                else
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            _buildPrevButton(context, state),
                                            const SizedBox(width: 8),
                                            _buildReplayButton(context, state),
                                            const SizedBox(width: 8),
                                            _buildNextButton(context, state),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              // Lottie Animation Overlay
              if (state.isCompleted)
                Positioned.fill(
                  child: IgnorePointer(
                    child: CongratulationOverlay(),
                  ),
                ),
            ],
          ), // closes Stack
          ); // closes WillPopScope
        },
      ), // closes BlocBuilder
      ), // closes MultiBlocListener
    ); // closes BlocProvider
  }

  Widget _buildAnimatedContainer(BuildContext context, DrawingState state, PracticeItem currentItem) {
    String currentText = currentItem.text;
    bool isWord = currentText.length > 1;
    bool showFullWordDemo = isWord && !state.isTracing && !state.isCompleted;
    bool showCompletedWord = isWord && state.isCompleted;
    
    String letterToDraw;
    bool skipAnimation = false;
    Duration animationDuration = const Duration(milliseconds: 1500);
    
    if (showFullWordDemo) {
      letterToDraw = currentText; // Show full word for demo
      skipAnimation = false;
      // Make demonstration faster for long words, but not too fast
      int wordLength = currentText.length;
      animationDuration = Duration(milliseconds: (4000 ~/ wordLength).clamp(600, 1500));
    } else if (isWord && !state.isCompleted) {
      letterToDraw = currentText[state.currentLetterIndex]; // Show single letter for tracing
      skipAnimation = true; // Skip animation since we already demonstrated the whole word
    } else {
      letterToDraw = currentText; // Single letter mode (A-Z)
      skipAnimation = false; // Always animate the single letter first
    }

    // Only show the progress indicator when we are actually tracing letter by letter
    bool showProgress = isWord && !showFullWordDemo && !showCompletedWord;

    return Column(
      children: [
        if (showProgress) _buildWordProgressIndicator(currentText, state.currentLetterIndex, currentItem.isCursive),
        if (showProgress) const SizedBox(height: 24),
        Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              border: Border.all(
                color: state.isAnimating ? Colors.redAccent : Colors.transparent,
                width: 4.0,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: showCompletedWord 
                ? _buildCompletedWord(currentText, currentItem.isCursive)
                : _buildDrawingArea(context, letterToDraw, currentItem, state.currentIndex, state.currentLetterIndex, state.replayId, isWord, skipAnimation, animationDuration),
          ),
        ),
      ],
    );
  }

  Widget _buildCompletedWord(String text, bool isCursiveMode) {
    return Center(
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) {
              return const LinearGradient(
                colors: [Colors.red, Colors.red, Colors.white, Colors.white],
                stops: [0.0, 0.5, 0.5, 1.0],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                tileMode: TileMode.repeated,
              ).createShader(const Rect.fromLTWH(0, 0, 30, 30));
            },
            child: Text(
              text,
              style: TextStyle(
                fontFamily: isCursiveMode ? 'cursive' : null,
                fontSize: 120,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 4.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWordProgressIndicator(String word, int currentIndex, bool isCursiveMode) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 0.0,
      runSpacing: 4.0,
      children: List.generate(word.length, (index) {
        bool isCompleted = index < currentIndex;
        bool isActive = index == currentIndex;
        
        return Text(
          word[index],
          style: TextStyle(
            fontFamily: isCursiveMode ? 'cursive' : null,
            fontSize: 42,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
            color: isCompleted ? Colors.green : (isActive ? Colors.blueAccent : Colors.grey.withAlpha(100)),
          ),
        );
      }),
    );
  }

  Widget _buildPrevButton(BuildContext context, DrawingState state) {
    return ElevatedButton.icon(
      onPressed: state.currentIndex > 0
          ? () => context.read<DrawingBloc>().add(DrawingPreviousLetterRequested())
          : null,
      icon: const Icon(Icons.arrow_back, size: 20),
      label: const Text('Prev'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildReplayButton(BuildContext context, DrawingState state) {
    return ElevatedButton.icon(
      onPressed: () => context.read<DrawingBloc>().add(DrawingReplayRequested()),
      icon: const Icon(Icons.replay, size: 20),
      label: const Text('Replay'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildNextButton(BuildContext context, DrawingState state) {
    bool isLastItem = state.currentIndex == state.items.length - 1;
    
    return ElevatedButton.icon(
      onPressed: state.isCompleted
          ? () {
              if (isLastItem) {
                Navigator.pop(context);
              } else {
                final nextItem = state.items[state.currentIndex + 1];
                if (PremiumManager.isItemLocked(nextItem.text)) {
                  // Paywall: If the next item is locked, show Subscription screen
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const SubscriptionPage()));
                } else {
                  context.read<DrawingBloc>().add(DrawingNextLetterRequested());
                }
              }
            }
          : null,
      icon: Icon(isLastItem ? Icons.check_circle : Icons.arrow_forward, size: 20),
      label: Text(isLastItem ? 'Finish' : 'Next'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildDrawingArea(BuildContext context, String text, PracticeItem item, int currentIndex, int currentLetterIndex, int replayId, bool isWord, bool skipAnimation, Duration animationDuration) {
    TracingStyle style = item.isCursive ? TracingStyle.cursive : TracingStyle.normal;

    return StrokeLine(
      key: ValueKey('${text}_${currentIndex}_${currentLetterIndex}_$replayId'),
      isCandyCane: true,
      text: text,
      skipAnimation: skipAnimation,
      tracingStyle: style,
      strokeColor: Colors.deepPurple,
      strokeWidth: 15.0,
      watermarkColor: Colors.grey.withAlpha(51),
      glowColor: Colors.purpleAccent,
      glowWidth: 5.0,
      animationDuration: animationDuration,
      onAnimationStart: () {
        context.read<DrawingBloc>().add(DrawingAnimationStarted());
        _speakLetter(text);
      },
      onTracingStart: () {
        context.read<DrawingBloc>().add(DrawingTracingStarted());
      },
      onComplete: () {
        if (isWord) {
          context.read<DrawingBloc>().add(DrawingSubLetterCompleted());
        } else {
          context.read<DrawingBloc>().add(DrawingCompleted());
        }
      },
    );
  }
}

class CongratulationOverlay extends StatefulWidget {
  const CongratulationOverlay({super.key});

  @override
  State<CongratulationOverlay> createState() => _CongratulationOverlayState();
}

class _CongratulationOverlayState extends State<CongratulationOverlay> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _playAudio();
  }

  Future<void> _playAudio() async {
    while (!_isDisposed) {
      try {
        if (!_isDisposed) {
          await _audioPlayer.play(AssetSource('animation/congratulation.mp3'));
        }
        
        // Keep playing for 4 seconds
        await Future.delayed(const Duration(seconds: 4));
        
        if (_isDisposed) break;
        
        // Stop and wait 300ms before looping again
        if (_audioPlayer.state == PlayerState.playing) {
          await _audioPlayer.stop();
        }
        await Future.delayed(const Duration(milliseconds: 300));
      } catch (e) {
        break; // Exit loop if any error occurs (like playing after dispose)
      }
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    try {
      // Safely stop before disposing to prevent native crashes
      _audioPlayer.stop().catchError((_) {}).whenComplete(() {
        _audioPlayer.dispose().catchError((_) {});
      });
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/animation/congratulation.json',
      repeat: true,
      fit: BoxFit.cover,
    );
  }
}
