import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khmer_speech_t0_text/app_controller.dart';

void main() {
  runApp(const GetMaterialApp(home: KhmerStt()));
}

class KhmerStt extends StatelessWidget {
  const KhmerStt({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = Get.put(AppController());
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
                  controller: appController.textController,
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontSize: 18, height: 1.4),
                  maxLines: null, // Allow multiline
                  expands: true, // Make TextField expand
                  decoration: const InputDecoration.collapsed(
                    hintText: 'ចុចរូបមេក្រូដើម្បីថតសំឡេង...',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Obx(() => FloatingActionButton.large(
        onPressed: appController.toggleListening,
        child: Icon(
          appController.isListening.value ? Icons.stop : Icons.mic,
          size: 36,
        ),
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
