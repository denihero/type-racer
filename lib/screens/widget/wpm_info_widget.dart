import 'package:flutter/material.dart';
import 'package:type_racer/screens/timer.dart';

Future wpmInfo(BuildContext context,int countWord) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text('Your wpm ${countWord / 1}'),
          actions: [
            ElevatedButton(onPressed: () {
              Navigator.pop(context);
              ///ToDo сделать кнопку сброса счетчика
            }, child: const Text('Повторить')),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Ok')),
          ],
        );
      });
}