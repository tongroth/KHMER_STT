import 'dart:typed_data';

import 'package:http/http.dart' as http;

class AzureTtsService {
  AzureTtsService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const _defaultVoice = 'km-KH-SreymomNeural';
  static const _outputFormat = 'audio-24khz-48kbitrate-mono-mp3';

  static const _apiKey = String.fromEnvironment('AZURE_SPEECH_KEY');
  static const _region = String.fromEnvironment('AZURE_SPEECH_REGION', defaultValue: 'eastus');

  Future<Uint8List> synthesize(String text) async {
    if (_apiKey.isEmpty) {
      throw StateError('Missing Azure Speech key. Provide AZURE_SPEECH_KEY via --dart-define.');
    }

    final endpoint = Uri.parse('https://$_region.tts.speech.microsoft.com/cognitiveservices/v1');
    final ssml = _buildSsml(text);

    final response = await _client.post(
      endpoint,
      headers: {
        'Content-Type': 'application/ssml+xml',
        'X-Microsoft-OutputFormat': _outputFormat,
        'Ocp-Apim-Subscription-Key': _apiKey,
        'User-Agent': 'khmer_speech_t0_text',
      },
      body: ssml,
    );

    if (response.statusCode != 200) {
      throw StateError('Azure TTS failed (${response.statusCode}): ${response.body}');
    }

    return response.bodyBytes;
  }

  String _buildSsml(String text) {
    final escapedText = text.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;');
    return '''
<speak version="1.0" xml:lang="km-KH">
  <voice xml:lang="km-KH" xml:gender="Female" name="$_defaultVoice">$escapedText</voice>
</speak>
''';
  }
}
