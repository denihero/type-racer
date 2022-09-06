import 'dart:async';

class Time{
  static const int tick = 60;

  Stream<int> counterStream =
  Stream<int>.periodic(const Duration(seconds: 1), (x) => tick - x - 1)
      .take(tick);
  int? duration = 60;
  StreamSubscription? streamSubscription;

  void resumeAndPause() {
    if(streamSubscription!.isPaused){
      streamSubscription?.resume();
    }else{
      streamSubscription?.pause();
    }
  }

}