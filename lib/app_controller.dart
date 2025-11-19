import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter/material.dart';

class AppController extends GetxController {
  // For Text Input and Character Sounds
  final textController = TextEditingController();
  final _audioPlayer = AudioPlayer();
  String _previousText = "";

  // For Speech to Text
  final _speechToText = SpeechToText();
  final isListening = false.obs;
  bool _isSpeechInitialized = false;

  @override
  void onInit() {
    super.onInit();
    _initialize();
    textController.addListener(_handleTextChange);
  }

  Future<void> _initialize() async {
    // Init audio player
    await _audioPlayer.setReleaseMode(ReleaseMode.release);
    // Init speech to text
    _isSpeechInitialized = await _speechToText.initialize(
      onError: (error) => print('Speech Error: $error'),
      onStatus: (status) => print('Speech Status: $status'),
    );
  }

  void _handleTextChange() {
    final newText = textController.text;
    if (newText.length > _previousText.length && newText.startsWith(_previousText)) {
      final newChar = newText.substring(_previousText.length);
      if (newChar.isNotEmpty) {
        _playSound(newChar[0]);
      }
    } else if (newText.length < _previousText.length && _previousText.startsWith(newText)) {
      _playSound('delete');
    }
    _previousText = newText;
  }

  Future<void> _playSound(String soundName) async {
    try {
      await _audioPlayer.play(AssetSource('sounds/$soundName.mp3'));
    } catch (e) {
      print("Error playing sound '$soundName.mp3': $e");
    }
  }

  void toggleListening() {
    if (isListening.value) {
      stopListening();
    } else {
      startListening();
    }
  }

  void startListening() {
    if (!_isSpeechInitialized) {
      print("Speech recognizer not initialized");
      return;
    }
    
    isListening.value = true;
    _speechToText.listen(
      onResult: (result) {
        // Only update the text field with the final result
        if (result.finalResult) {
          textController.text = result.recognizedWords;
          // Move cursor to the end
          textController.selection = TextSelection.fromPosition(TextPosition(offset: textController.text.length));
        }
      },
      localeId: 'km_KH', // Khmer language
      listenFor: const Duration(minutes: 1), // Set a longer listen duration
    );
  }

  void stopListening() {
    isListening.value = false;
    _speechToText.stop();
  }

  @override
  void onClose() {
    textController.dispose();
    _audioPlayer.dispose();
    super.onClose();
  }
}
