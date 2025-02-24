import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

const double windowWidth = 360;
const double windowHeight = 640;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Provider Counter');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

class Counter with ChangeNotifier {
  int value = 0;

  void increment() {
    value += 1;
    notifyListeners();
  }

  void decrement() {
    if (value > 0) {
      value -= 1;
      notifyListeners();
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Age Milestone Counter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  String getMilestoneMessage(int age) {
    if (age <= 12) {
      return "You're a child!";
    } else if (age <= 19) {
      return "Teenager time!";
    } else if (age <= 30) {
      return "You're a young adult!";
    } else if (age <= 50) {
      return "Ew your an adult now!";
    } else {
      return "Golden years!";
    }
  }

  Color getBackgroundColor(int age) {
    if (age <= 12) {
      return Colors.deepPurple;
    } else if (age <= 19) {
      return Colors.pinkAccent;
    } else if (age <= 30) {
      return Colors.blueAccent
    } else if (age <= 50) {
      return Colors.redAccent;
    } else {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    var counter = context.watch<Counter>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Age Milestone Counter'),
      ),
      backgroundColor: getBackgroundColor(counter.value),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(getMilestoneMessage(counter.value),
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),
            Text('${counter.value}',
                style: Theme.of(context).textTheme.displayLarge),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: counter.decrement,
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
          FloatingActionButton(
            onPressed: counter.increment,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
