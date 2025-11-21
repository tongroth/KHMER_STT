import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';

import 'azure_tts_service.dart';

class TextController extends GetxController {
  final text = ''.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  String _previousText = "";
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AzureTtsService _ttsService = AzureTtsService();
  bool _isAudioInitialized = true; // To track if audio is unlocked on web

  @override
  void onInit() {
    super.onInit();
    // Good practice for playing many short sounds.
    _audioPlayer.setReleaseMode(ReleaseMode.release);
    ever(text, _handleTextChanged);
  }

  // This must be called from a user gesture on web to unlock audio.
  void initAudio() {
    if (_isAudioInitialized) return;
    _isAudioInitialized = true;
    print("Audio Initialized by user gesture.");
  }

  void _handleTextChanged(String newText) {
    // On web, audio must be unlocked by a user gesture first.
    if (GetPlatform.isWeb && !_isAudioInitialized) {
      print("Audio not initialized. Please click the button first.");
      return;
    }

    // Handles adding a new character
    if (newText.length > _previousText.length && newText.startsWith(_previousText)) {
      final newChar = newText.substring(_previousText.length);
      // This simple logic plays a sound for the first new character.
      if (newChar.isNotEmpty) {
        if (newChar[0] == ' ') {
          _playSound('space'); // play space.mp3
        } else {
          _playSound(newChar[0]);
        }
      }
    }
    // Handles deleting a character
    else if (newText.length < _previousText.length && _previousText.startsWith(newText)) {
      _playSound('delete');
    }
    _previousText = newText;
  }

  Future<void> speakCurrentText() async {
    if (text.value.trim().isEmpty) {
      errorMessage.value = 'សូមបញ្ចូលអត្ថបទមុនពេលបម្លែង។';
      return;
    }

    errorMessage.value = '';
    isLoading.value = true;

    try {
      final Uint8List audioBytes = await _ttsService.synthesize(text.value.trim());
      await _audioPlayer.play(BytesSource(audioBytes));
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _playSound(String soundName) async {
    // Note: Ensure your filenames are valid. For example, name the file for
    // the '/' character 'slash.mp3' and handle that mapping here.
    try {
      await _audioPlayer.play(AssetSource('sounds/$soundName.mp3'));
    } catch (e) {
      print("Error playing sound '$soundName.mp3': $e");
    }
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}
