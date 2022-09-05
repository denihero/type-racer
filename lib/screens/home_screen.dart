import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:type_racer/constant/text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextCollections textCollections = TextCollections();
  late TextEditingController textEditingController;
  late FocusNode focusNode;
  late bool isCorrect;
  late String text;

  @override
  void initState() {
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    isCorrect = false;
    getNewWords();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void getNewWords() {
    setState(() {
      text = textCollections.commonWords[Random().nextInt(textCollections.commonWords.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TypeRacer'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(fontSize: 20,color: isCorrect ? Colors.green:Colors.red),
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RawKeyboardListener(
              focusNode: focusNode,
              onKey: (event){
                if(event.data.logicalKey == LogicalKeyboardKey.space && isCorrect == true){
                  isCorrect = false;
                  getNewWords();
                  textEditingController.clear();
                }
              },
              child: TextFormField(
                controller: textEditingController,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp('[ ]')),
                  ],
                onChanged: (value) {
                  if (value.trim() == text) {
                    isCorrect = true;
                  }else{
                  }
                },
                decoration: const InputDecoration(
                    hintText: 'Type your text', border: OutlineInputBorder()),
              ),
            ),
          )
        ],
      ),
    );
  }
}
