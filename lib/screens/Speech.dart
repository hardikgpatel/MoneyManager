import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechCommandScreen extends StatefulWidget {
  static const routeName = 'SpeechCommandScreen';

  @override
  _SpeechCommandScreenState createState() => _SpeechCommandScreenState();
}

class _SpeechCommandScreenState extends State<SpeechCommandScreen> {
  bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = '';
  String lastError = '';
  String lastStatus = '';
  String _currentLocaleId = '';
  int resultListened = 0;
  bool isExpanse = false;
  bool isIncome = false;
  String amount = "";
  List<LocaleName> _localeNames = [];
  final SpeechToText speech = SpeechToText();

  @override
  void initState() {
    super.initState();
    _hasSpeech ? null : initSpeechState();
  }

  Future<void> initSpeechState() async {
    var hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener, debugLogging: true);
    if (hasSpeech) {
      _localeNames = await speech.locales();

      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale!.localeId;
    }

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speak to go'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: Theme.of(context).selectedRowColor,
                    child: Column(
                      children: [
                        SizedBox(height: 20.0,),
                        Center(
                          child: Text(
                            lastWords,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 20.0,),
                        if (lastWords.isNotEmpty)
                          ((isExpanse || isIncome) && amount.isNotEmpty)
                              ? Text(
                                  'transaction of $amount as ${isExpanse ? 'Expanse' : ''}${isIncome ? 'Income' : ''}')
                              : Text('Bade try')
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Card(
                  shape: StadiumBorder(),
                  child: Container(
                    width: 60,
                    height: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: .26,
                          spreadRadius: level * 1.5,
                          color: Colors.black.withOpacity(.05),
                        )
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.mic),
                      onPressed: () {
                        if (!speech.isListening) {
                          startListening();
                        } else if (speech.isListening) {
                          stopListening();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Column(
            children: <Widget>[
              Center(
                child: Text(
                  'Error Status',
                  style: TextStyle(fontSize: 22.0),
                ),
              ),
              Center(
                child: Text(lastError),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            color: Theme.of(context).backgroundColor,
            child: Center(
              child: speech.isListening
                  ? Text(
                      "I'm listening...",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  : Text(
                      'Not listening',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void startListening() {
    lastWords = '';
    lastError = '';
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 5),
        pauseFor: Duration(seconds: 5),
        partialResults: false,
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        listenMode: ListenMode.confirmation);
    setState(() {});
  }

  void stopListening() {
    speech.stop();
    setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    ++resultListened;
    print('Result listener $resultListened - $result');
    List<String> words = result.recognizedWords.split(" ");
    bool exp = words.contains("Kharcha") || words.contains("paid") || words.contains("pay") || words.contains("given") || words.contains("spent") || words.contains("spend");
    bool incm = words.contains("back") || words.contains("add");
    String amt="";
    words.forEach((element) {
      final number = num.tryParse(element);
      if (number != null) {
        amt = element;
      }
    });
    print('$exp - $incm - $amt - ${words.contains("pay")} - $words');
    setState(() {
      lastWords = '${result.recognizedWords}';
      isExpanse = exp;
      isIncome = incm;
      amount = amt;
    });
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    // print("sound level $level: $minSoundLevel - $maxSoundLevel ");
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    // print("Received error status: $error, listening: ${speech.isListening}");
    setState(() {
      lastError = '${error.errorMsg} - ${error.permanent}';
    });
  }

  void statusListener(String status) {
    // print(
    // 'Received listener status: $status, listening: ${speech.isListening}');
    setState(() {
      lastStatus = '$status';
    });
  }

  void _switchLang(selectedVal) {
    setState(() {
      _currentLocaleId = selectedVal;
    });
    print(selectedVal);
  }
}
