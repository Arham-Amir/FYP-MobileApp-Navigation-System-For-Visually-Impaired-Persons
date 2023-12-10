import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class Helper {
  FlutterTts ftts = FlutterTts();
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = "";

  Future<void> speak(String text) async {
    var result = await ftts.speak(text);
    if (result == 1) {
      // Handle successful speech
    } else {
      // Handle speech error
    }
  }

  Future<void> startListening(Function(String) onCommand) async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        _isListening = true;
        _speech.listen(onResult: (val) {
          _text = val.recognizedWords;
          onCommand(_text);
        });
      }
    }
  }

  void stopListening() async {
    _isListening = false;

    await _speech.stop();
  }
}
