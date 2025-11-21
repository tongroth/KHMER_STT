import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khmer_speech_t0_text/text_controller.dart';

void main() {
  runApp(const GetMaterialApp(home: KhmerStt()));
}

class KhmerStt extends StatelessWidget {
  const KhmerStt({super.key});

  @override
  Widget build(BuildContext context) {
    final textController = Get.put(TextController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Khmer Speech → Text (Microsoft TTS)'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  onChanged: (value) => textController.text.value = value,
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontSize: 18, height: 1.4),
                  maxLines: null, // Allow multiline
                  expands: true, // Make TextField expand
                  decoration: const InputDecoration.collapsed(
                    hintText: 'ប៊ូតុងខាងក្រោម៖ ចុចដើម្បីបម្លែងអត្ថបទទៅសំលេង។',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: textController.isLoading.value
                        ? null
                        : () {
                            textController.initAudio();
                            textController.speakCurrentText();
                          },
                    icon: textController.isLoading.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.volume_up),
                    label: Text(
                      textController.isLoading.value
                          ? 'កំពុងបម្លែង...'
                          : 'បម្លែងជាសំលេង (Azure)',
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                    ),
                  ),
                  if (textController.errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        textController.errorMessage.value,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
