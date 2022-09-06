import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:type_racer/screens/home_screen.dart';
import 'package:type_racer/screens/timer.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Time>(create: (_) => Time()),
      ],
      child: const MaterialApp(
        home: HomeScreen(),
      ),
    );
  }
}
