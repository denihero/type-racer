import 'dart:async';

import 'package:flutter/cupertino.dart';

class Time extends ChangeNotifier{
  static const int tick = 2;

  Stream<int> counterStream =
  Stream<int>.periodic(const Duration(seconds: 1), (x) => tick - x - 1)
      .take(tick);
  int duration = tick;
  StreamSubscription? streamSubscription;

  void resumeAndPause() {
    if(streamSubscription!.isPaused){
      streamSubscription?.resume();
    }else{
      streamSubscription?.pause();
    }
  }

  void reset() {

  }

}