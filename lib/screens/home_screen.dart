import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:type_racer/constant/text.dart';
import 'package:type_racer/screens/timer.dart';
import 'package:type_racer/screens/widget/wpm_info_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextCollections textCollections = TextCollections();
  final Time time = Time();
  late TextEditingController textEditingController;
  late FocusNode focusNode;
  late bool isCorrect;
  late String text;
  int countWord = 0;

  @override
  void initState() {
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    isCorrect = false;
    time.streamSubscription = time.counterStream.listen((event) {
      print(event);
      setState(() {
        time.duration = event;
      });
      if (time.duration <= 0) {
        textEditingController.clear();
        Future.delayed(Duration.zero, () {
          wpmInfo(context, countWord);
        });
      }
    });
    time.streamSubscription?.pause();
    getNewWords();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    time.streamSubscription?.cancel();
    focusNode.dispose();
    super.dispose();
  }

  void reset() {
    time.streamSubscription?.cancel();
    time.streamSubscription = time.counterStream.listen((event) {
      setState(() {
        time.duration = event;
      });
    });
  }

  void getNewWords() {
    setState(() {
      text = textCollections
          .commonWords[Random().nextInt(textCollections.commonWords.length)];
    });
  }


  @override
  Widget build(BuildContext context) {
    final minutesStr = ((time.duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (time.duration % 60).floor().toString().padLeft(2, '0');
    return Scaffold(
      appBar: AppBar(
        title: const Text('TypeRacer'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 50,
          ),
          Text('$minutesStr:$secondsStr',style: const TextStyle(fontSize: 40),),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${text}',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RawKeyboardListener(
                    focusNode: focusNode,
                    onKey: (event) {
                      if (event.data.logicalKey == LogicalKeyboardKey.space &&
                          isCorrect == true) {
                        isCorrect = false;
                        getNewWords();
                        countWord++;
                        textEditingController.clear();
                      }
                    },
                    child: TextFormField(
                      enabled: time.streamSubscription!.isPaused ? false:time.duration <=0 ? false:true,
                      autofocus: time.streamSubscription!.isPaused? false:true,
                      controller: textEditingController,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp('[ ]')),
                      ],
                      onChanged: (value) {
                        if (value.trim() == text) {
                          isCorrect = true;
                        } else {
                          isCorrect = false;
                        }
                      },
                      decoration: const InputDecoration(
                          hintText: 'Type your text', border: OutlineInputBorder()),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(onPressed: () {
                      time.resumeAndPause();
                      setState(() {
                      });
                    }, icon: time.streamSubscription!.isPaused ? const Icon(Icons.play_arrow):const Icon(Icons.pause)),
                    const SizedBox(
                      width: 30,
                    ),
                    IconButton(onPressed: () {
                      reset();
                    }, icon: const Icon(Icons.replay))
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
