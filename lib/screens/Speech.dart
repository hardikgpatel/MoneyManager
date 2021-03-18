import 'dart:async';
import 'dart:math';

import 'package:MoneyManager/model/transaction_model.dart';
import 'package:MoneyManager/provider/transaction_provider.dart';
import 'package:MoneyManager/provider/wallet_provider.dart';
import 'package:MoneyManager/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechCommandScreen extends HookWidget {
  static const routeName = 'SpeechCommandScreen';

  @override
  Widget build(BuildContext context) {
    final _hasSpeech = useState(false);
    final level = useState<double>(0.0);
    final minSoundLevel = useState<double>(50000);
    final maxSoundLevel = useState<double>(-50000);
    final lastWords = useState('');
    final lastError = useState('');
    final lastStatus = useState('');
    final _currentLocaleId = useState('');
    final resultListened = useState(0);
    final isExpanse = useState(false);
    final isIncome = useState(false);
    final amount = useState('');
    final _localeNames = useState<List<LocaleName>>([]);
    final SpeechToText speech = SpeechToText();

    final transactions = useProvider(transactionProvider.state);
    final wallets = useProvider(walletProvider.state);

    resultListener(SpeechRecognitionResult result) {
      ++resultListened.value;
      print('Result listener $resultListened - $result');
      List<String> words = result.recognizedWords.split(" ");
      isExpanse.value = words.contains("chukavya") ||
          words.contains("apya") ||
          words.contains("kharcha") ||
          words.contains("paid") ||
          words.contains("pay") ||
          words.contains("given") ||
          words.contains("spent") ||
          words.contains("debited") ||
          words.contains("spend");
      isIncome.value = words.contains("back") || words.contains("add") || words.contains("credited");
      words.forEach((element) {
        final number = num.tryParse(element);
        if (number != null) {
          amount.value = element;
        }
      });

      void showAlert(String title, String message) {
        Utils.showCustomDialog(context: context, title: title, content: message);
      }

      if ((isExpanse.value || isIncome.value) && amount.value.isNotEmpty) {
        Utils.showTransactionDialog(
            context: context,
            title: 'transaction',
            content:
                'transaction of ${amount.value} as ${isExpanse.value ? 'Expanse' : ''}${isIncome.value ? 'Income' : ''}',
            onSubmit: () {

              var wallet = wallets.firstWhere((element) {
                if(isExpanse.value) {
                  if(element.isDefault && element.amount >= int.parse(amount.value))
                    return true;
                } else {
                  return true;
                }
                return false;
              });

              if(wallet == null) {
                wallet= wallets.firstWhere((element){
                  if(isIncome.value) {
                    return true;
                  } else if (element.amount >= int.parse(amount.value)){
                    return true;
                  }
                  return false;
                });
              }

              TransactionModel _transaction = TransactionModel(
                title: 'Voice command',
                amount: int.parse(amount.value),
                wallet: wallet.id,
                description: result.recognizedWords,
                transactionDate: DateTime.now(),
                isExpance: isExpanse.value,
              );

              context
                  .read(transactionProvider)
                  .addTransaction(_transaction);
              showAlert('Success', 'Transaction added');
            });
      } else {
        showAlert('Error', 'Sorry, not hear you properly please give proper command');
      }

      print(
          'update = ${amount.value} - ${isIncome.value} - ${isExpanse.value}');
    }

    void soundLevelListener(double lvl) {
      minSoundLevel.value = min(minSoundLevel.value, lvl);
      maxSoundLevel.value = max(maxSoundLevel.value, lvl);
      level.value = lvl;
    }

    void startListening() {
      lastWords.value = '';
      lastError.value = '';
      speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 5),
        pauseFor: Duration(seconds: 5),
        partialResults: false,
        localeId: _currentLocaleId.value,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        listenMode: ListenMode.confirmation,
      );
    }

    void stopListening() {
      speech.stop();
      level.value = 0.0;
    }

    void errorListener(SpeechRecognitionError error) {
      lastError.value = '${error.errorMsg} - ${error.permanent}';
    }

    void statusListener(String status) {
      lastStatus.value = '$status';
    }

    Future<void> initSpeechState() async {
      var hasSpeech = await speech.initialize(
          onError: errorListener, onStatus: statusListener, debugLogging: true);
      if (hasSpeech) {
        _localeNames.value = await speech.locales();
        var systemLocale = await speech.systemLocale();
        _currentLocaleId.value = systemLocale!.localeId;
      }
      _hasSpeech.value = hasSpeech;
    }

    _hasSpeech.value ? null : initSpeechState();
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
                        SizedBox(
                          height: 20.0,
                        ),
                        Center(
                          child: Text(
                            lastWords.value,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        if (lastWords.value.isNotEmpty)
                          ((isExpanse.value || isIncome.value) &&
                                  amount.value.isNotEmpty)
                              ? Text(
                                  'transaction of ${amount.value} as ${isExpanse.value ? 'Expanse' : ''}${isIncome.value ? 'Income' : ''}')
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
                          spreadRadius: level.value * 1.5,
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
                child: Text(lastError.value),
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
}
