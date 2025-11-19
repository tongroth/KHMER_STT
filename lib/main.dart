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
        title: const Text('Khmer Speech → Text (Google)'),
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
                    hintText: 'ប៊ូតុងខាងក្រោម៖ ចុចដើម្បីថត បន្ទាប់មកបញ្ឈប់ដើម្បីបម្លែង។',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: textController.initAudio,
        child: const Icon(Icons.mic, size: 36),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
