import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ramen Timer',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
      ),
      home: ChangeNotifierProvider<_Timer>(
          create: (_) => _Timer(), child: _TimerWidget(title: 'Ramen Timer')),
    );
  }
}

const int _ramenTimeSec = 10; //180;

class _Timer extends ChangeNotifier {
  Timer _currentTimer;
  DateTime _startTime;
  void Function() _onComplete = () {};

  void _timerStart() {
    _startTime = DateTime.now();
    _currentTimer = Timer.periodic(Duration(milliseconds: 250), (Timer _) {
      if (_remainingTime() <= 0) {
        _currentTimer.cancel();
        _startTime = null;
        _onComplete.call();
      }
      notifyListeners();
    });
  }

  void setCompleteEvent(BuildContext context) {
    _onComplete = () {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Boiling Ramen is finished!"),
              actions: [
                TextButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ],
            );
          });
    };
  }

  void _timerStop() {
    _currentTimer.cancel();
    _startTime = null;
    notifyListeners();
  }

  bool _isStopped() {
    return _startTime == null;
  }

  int _remainingTime() {
    if (_startTime == null) return 0;
    return _ramenTimeSec - DateTime.now().difference(_startTime).inSeconds;
  }

  String _timerText() {
    int remainingTime = _remainingTime();
    int min = remainingTime ~/ 60;
    int sec = remainingTime % 60;
    return min.toString().padLeft(2, "0") +
        ":" +
        sec.toString().padLeft(2, "0");
  }
}

class _TimerText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _Timer timer = Provider.of<_Timer>(context);
    timer.setCompleteEvent(context);
    return Text(timer._timerText(),
        style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5));
  }
}

class _TimerButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _Timer timer = Provider.of<_Timer>(context);
    if (timer._isStopped()) {
      return IconButton(
        onPressed: timer._timerStart,
        tooltip: 'Start',
        icon: Icon(Icons.play_circle_outline),
        iconSize: 48,
      );
    }
    return IconButton(
      onPressed: timer._timerStop,
      tooltip: 'Stop',
      icon: Icon(Icons.stop_circle_outlined),
      iconSize: 48,
    );
  }
}

class _TimerWidget extends StatelessWidget {
  _TimerWidget({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _TimerText(),
            _TimerButton(),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed:
      //       Provider.of<_TimerNotifier>(context, listen: false)._timerStart,
      //   tooltip: 'Start',
      //   child: Icon(Icons.play_arrow),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
