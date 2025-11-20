import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/material.dart';

class AppController extends GetxController {
  // For Text Input and Character Sounds
  final textController = TextEditingController();
  final _audioPlayer = AudioPlayer();
  String _previousText = "";
  bool _isUpdatingFromVoice = false;

  // For Speech to Text
  stt.SpeechToText speech = stt.SpeechToText();
  final isListening = false.obs;
  bool _isSpeechInitialized = false;

  @override
  void onInit() {
    super.onInit();
    _initialize();
    textController.addListener(_handleTextChange);
  }

  Future<void> _initialize() async {
    // Optimized for low latency
    await _audioPlayer.setReleaseMode(ReleaseMode.stop);

    _isSpeechInitialized = await speech.initialize(
      onError: (error) => print('Speech Error: $error'),
      onStatus: (status) => print('Speech Status: $status'),
    );
  }

  void _handleTextChange() {
    if (_isUpdatingFromVoice) {
      _previousText = textController.text;
      return;
    }

    final newText = textController.text;
    if (newText.length > _previousText.length) {
      if (newText.startsWith(_previousText)) {
        String newChar = newText.substring(_previousText.length);
        if (newChar.isNotEmpty) {
          _playCharacterSound(newChar[0]);
        }
      }
    } else if (newText.length < _previousText.length) {
      _playSound('delete');
    }

    _previousText = newText;
  }

  Future<void> _playCharacterSound(String char) async {
    String soundFile = char.toLowerCase();

    if (char == " ") soundFile = "space";
    if (char == ".") soundFile = "dot";

    _playSound(soundFile);
  }

  Future<void> _playSound(String soundName) async {
    try {
      await _audioPlayer.stop();
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
    speech.listen(
      onResult: (result) {
        _isUpdatingFromVoice = true;

        // For web, we must replace the text with each result for real-time feedback.
        textController.text = result.recognizedWords;

        textController.selection = TextSelection.fromPosition(
            TextPosition(offset: textController.text.length));

        _isUpdatingFromVoice = false;
      },
      localeId: 'km_KH', // Khmer
      listenFor: const Duration(minutes: 1),
    );
  }

  void stopListening() {
    isListening.value = false;
    speech.stop();
  }

  @override
  void onClose() {
    textController.dispose();
    _audioPlayer.dispose();
    super.onClose();
  }
}
