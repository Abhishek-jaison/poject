import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class VoiceRecorderWidget extends StatefulWidget {
  final Function(String) onRecordingDone;

  const VoiceRecorderWidget({Key? key, required this.onRecordingDone})
    : super(key: key);

  @override
  _VoiceRecorderWidgetState createState() => _VoiceRecorderWidgetState();
}

class _VoiceRecorderWidgetState extends State<VoiceRecorderWidget>
    with SingleTickerProviderStateMixin {
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isRecording = false;
  bool isPlaying = false;
  String? _recordedFilePath;

  late AnimationController _animationController;
  late List<Animation<double>> _dotAnimations;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    // Create animations for the 4 dots
    _dotAnimations = List.generate(4, (index) {
      return Tween<double>(begin: 10, end: 30).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(index * 0.2, 1.0, curve: Curves.easeInOut),
        ),
      );
    });

    // Start the animation when recording starts
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });

    // Listen to audio player state changes
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
      });
    });
  }

  Future<String> _getRecordingPath() async {
    // Get the directory for storing the audio file
    final directory = await getApplicationDocumentsDirectory();
    // Generate a unique file name using a timestamp
    final fileName = 'recording_${DateTime.now().millisecondsSinceEpoch}.aac';
    // Combine the directory path and file name
    return '${directory.path}/$fileName';
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        // Generate a file path for the recording
        final path = await _getRecordingPath();

        // Start recording
        await _audioRecorder.start(
          RecordConfig(
            encoder: AudioEncoder.aacLc, // Audio encoder
            bitRate: 128000, // Bit rate
            sampleRate: 44100, // Sample rate
          ),
          path: path, // File path
        );

        setState(() {
          isRecording = true;
          _recordedFilePath = path;
        });

        // Start the animation
        _animationController.forward();
      } else {
        print("Permission denied for audio recording.");
      }
    } catch (e) {
      print("Failed to start recording: $e");
    }
  }

  Future<void> _stopRecording() async {
    try {
      if (isRecording) {
        String? path = await _audioRecorder.stop();
        if (path != null) {
          widget.onRecordingDone(path);
          setState(() {
            _recordedFilePath = path;
          });
        }
        setState(() {
          isRecording = false;
        });

        // Stop the animation
        _animationController.stop();
      }
    } catch (e) {
      print("Failed to stop recording: $e");
    }
  }

  Future<void> _playRecording() async {
    try {
      if (_recordedFilePath != null) {
        if (isPlaying) {
          await _audioPlayer.stop();
          setState(() {
            isPlaying = false;
          });
        } else {
          await _audioPlayer.play(DeviceFileSource(_recordedFilePath!));
          setState(() {
            isPlaying = true;
          });
        }
      }
    } catch (e) {
      print("Failed to play recording: $e");
    }
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Record button
        GestureDetector(
          onTap: () {
            if (isRecording) {
              _stopRecording();
            } else {
              _startRecording();
            }
          },
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isRecording ? Colors.red : Color(0xFFE6BFFF),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.mic, size: 40, color: Colors.white),
          ),
        ),
        SizedBox(width: 16),
        // Recording animation
        if (isRecording)
          Container(
            height: 50, // Fixed height for the dots container
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return AnimatedBuilder(
                  animation: _dotAnimations[index],
                  builder: (context, child) {
                    return Container(
                      width: 10,
                      height: _dotAnimations[index].value,
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        // Play button (shows only when there's a recording)
        if (!isRecording && _recordedFilePath != null) ...[
          SizedBox(width: 16),
          GestureDetector(
            onTap: _playRecording,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFE6BFFF),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPlaying ? Icons.stop : Icons.play_arrow,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
