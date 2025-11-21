# Khmer Speech → Text

This Flutter app lets you enter Khmer text and convert it to speech in real time using Microsoft Azure Speech.

## Azure Speech setup

The app reads your Azure credentials from Dart defines so you do **not** hard-code keys in source control.

```
flutter run \
  --dart-define=AZURE_SPEECH_KEY=<your_subscription_key> \
  --dart-define=AZURE_SPEECH_REGION=<your_region> # defaults to eastus
```

Recommended Khmer neural voice: `km-KH-SreymomNeural` (already set as the default).
