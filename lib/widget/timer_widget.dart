import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TimerWidget extends StatelessWidget {
  TimerWidget({required this.time});

  final DateTime time;

  @override
  Widget build(BuildContext context) {
    String _number = '0', _unit = 'day';

    final now = DateTime.now();
    final difference = time.difference(now);

    final diffInDays = difference.inDays;
    final diffInHours = difference.inHours;
    final diffInMinutes = difference.inMinutes;
    final diffInSeconds = difference.inSeconds;

    print('diddd d : ${diffInDays}');

    if (diffInDays > 2) {
      _number = '';
      _unit = '${time.day}/${time.month}/${time.year} ${time.hour}:${time.minute}:${time.second}';
    } else if (diffInDays > 1) {
      _number = diffInDays.toString();
      _unit = 'day';
    } else if (diffInDays == 1) {
      _number = '';
      _unit = 'Yesterday';
    } else if (diffInHours > 0) {
      _number = diffInHours.toString();
      _unit = 'hour';
    } else if (diffInMinutes > 0) {
      _number = diffInMinutes.toString();
      _unit = 'minute';
    } else if (diffInSeconds > 0) {
      _number = diffInSeconds.toString().padLeft(2, '0');
      _unit = 'second';
    }

    return Row(
      children: <Widget>[
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: _number,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xff8E8D8D),
                    fontSize: 12,
                  )),
              TextSpan(
                text: ' $_unit ago',
                style: TextStyle(
                  color: Color(0xff8E8D8D),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
