import 'package:flutter/material.dart';
import 'Ataxx_Game.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ataxx',
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
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _play_with_cpu = false;
  bool CPU_starts = false;
  int CPU_difficulty = 2;

  List<String> CPU_difficulties = [
    'Very Easy',
    'Easy',
    'Medium',
    'Hard',
    'Extreme',
  ];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(190),
        child: FractionallySizedBox(
          widthFactor: 0.6,
          heightFactor: 0.5,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Image.asset(
                'images/Ataxx.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Text(
            'Select Game Type: ',
            style: TextStyle(fontSize: 24),
          ),
          RadioListTile<bool>(
            title: const Text('2 Players'),
            value: false,
            groupValue: _play_with_cpu,
            onChanged: (bool? value) {
              setState(() {
                _play_with_cpu = value as bool;
              });
            },
          ),
          RadioListTile<bool>(
            title: const Text('Player vs CPU'),
            value: true,
            groupValue: _play_with_cpu,
            onChanged: (bool? value) {
              setState(() {
                _play_with_cpu = value as bool;
              });
            },
          ),
          Text('     Select CPU difficulty:   ',
              style: TextStyle(fontSize: 18)),
          DropdownButton<int>(
            value: CPU_difficulty,
            items: [0, 1, 2, 3, 4].map((int value) {
              return new DropdownMenuItem<int>(
                value: value,
                child: new Text(CPU_difficulties[value]),
              );
            }).toList(),
            onChanged: (int? newValue) {
              setState(() {
                CPU_difficulty = newValue as int;
              });
            },
          ),
          CheckboxListTile(
            title: Text('CPU starts first', style: TextStyle(fontSize: 18)),
            value: CPU_starts,
            onChanged: (bool? value) {
              setState(() {
                CPU_starts = value as bool;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          TextButton(
              onPressed: () {
                Ataxx_Game ag = Ataxx_Game(
                    play_with_cpu: _play_with_cpu,
                    CPU_difficulty: CPU_difficulty,
                    CPU_starts: CPU_starts);

                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => ag));
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey,
              ),
              child: Text(
                'Start Game',
                style: TextStyle(
                    fontSize: 18, foreground: Paint()..color = Colors.black),
              )),
        ],
      ),
    );
  }
}
