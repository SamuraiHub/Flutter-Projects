import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'charts.dart';
import 'gold.dart';
import 'dart:async';
import 'convert.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'We-Earn Finance',
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

class Model {
  final double a;
  final double b;
  final String s;

  Model._({this.a, this.b, this.s});

  factory Model.fromJson(Map<String, dynamic> json) {
    return new Model._(
      a: json['a'].toDouble(),
      b: json['b'].toDouble(),
      s: json['s'],
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title = 'We Earn Finance'}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Timer _timer;
  bool dispos = false;

  List<List<String>> currencyPair = [
    ["USD-TRY", "0", "0"],
    ["EUR-USD", "0", "0"],
    ['EUR-TRY', "0", "0"],
    ['CAD-TRY', "0", "0"],
    ['GBP-TRY', "0", "0"],
    ['AUD-TRY', "0", "0"],
    ['JPY-TRY', "0", "0"],
    ['CHF-TRY', "0", "0"],
    ['AED-TRY', "0", "0"],
    ['QAR-TRY', "0", "0"],
    ['BGN-TRY', "0", "0"],
    ['DKK-TRY', "0", "0"],
    ['SAR-TRY', "0", "0"],
    ['CNY-TRY', "0", "0"],
    ['RUB-TRY', "0", "0"],
    ['NOK-TRY', "0", "0"],
    ['SEK-TRY', "0", "0"]
  ];

  double round_to_4(double d)
  {
    double fac = pow(10.0, 5);
    double x = d * fac/10.0;
    fac = pow(10.0, 4);
    return (x).round() / fac;
  }


  void fetchPairValue() async {

    final response = await http.get('https://api.1forge.com/quotes?pairs=USD/TRY,EUR/USD,EUR/TRY,CAD/TRY,GBP/TRY,AUD/TRY,JPY/TRY,CHF/TRY,AED/TRY,USD/QAR,USD/BGN,DKK/TRY,USD/SAR,USD/CNY,USD/RUB,NOK/TRY,SEK/TRY'
        '&api_key=KatWbQa9sDFmYQ25LmtAMlGau5xKSWIe');

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON

      /*[{"p":1.21856,"a":1.22201,"b":1.2151,"s":"EUR/USD","t":1608934265255},{"p":7.5575,"a":7.5625,"b":7.5525,"s":"USD/TRY","t":1608908143931},{"p":9.26299,"a":9.27256,"b":9.25342,"s":"EUR/TRY","t":1608879625018},
        {"p":6.037513,"a":6.039437,"b":6.035589,"s":"CAD/TRY","t":1608933871214},{"p":10.297348,"a":10.316695,"b":10.278,"s":"GBP/TRY","t":1608879629130},{"p":5.7738,"a":5.7885,"b":5.7591,"s":"AUD/TRY","t":1608879564069},
        {"p":0.07303697,"a":0.07308529,"b":0.07298864,"s":"JPY/TRY","t":1608908143937},{"p":8.529457,"a":8.538269,"b":8.520645,"s":"CHF/TRY","t":1608879624835},
        {"p":2.057672,"a":2.059033,"b":2.056311,"s":"AED/TRY","t":1608908143934},{"p":3.6413,"a":3.642,"b":3.6405,"s":"USD/QAR","t":1608847204796},{"p":1.6069188,"a":1.61497,"b":1.5988675,"s":"USD/BGN","t":1608861813327},
        {"p":1.2452666,"a":1.2465531,"b":1.24398,"s":"DKK/TRY","t":1608879625024},{"p":3.752353,"a":3.755106,"b":3.7496,"s":"USD/SAR","t":1608879629251},{"p":6.5418,"a":6.5428,"b":6.5408,"s":"USD/CNY","t":1608909993197},
        {"p":74.06,"a":74.095,"b":74.025,"s":"USD/RUB","t":1608930021562},{"p":0.87736,"a":0.878167,"b":0.876553,"s":"NOK/TRY","t":1608847205092},{"p":0.917155,"a":0.918032,"b":0.916278,"s":"SEK/TRY","t":1608847203927}]*/

      List<Model> list  = json.decode(response.body).map<Model>((data) => Model.fromJson(data))
          .toList();

      setState(() {

        currencyPair[0][1] = round_to_4(list[0].b).toString();
        currencyPair[0][2] = round_to_4(list[0].a).toString();

        for (int i = 1; i < currencyPair.length; i++) {

          if(list[i].s.startsWith('USD'))
          {
            currencyPair[i][1] = round_to_4(list[i].b/list[1].b).toString();
            currencyPair[i][2] = round_to_4(list[i].a/list[1].a).toString();
          }
          else {
            currencyPair[i][1] = round_to_4(list[i].b).toString();
            currencyPair[i][2] = round_to_4(list[i].a).toString();
          }
        }
      });
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  List<DataRow> rows = List<DataRow>(17);

  void setTable() {

    for (int i = 0; i < currencyPair.length; i++) {
      rows[i] = DataRow(
        cells: <DataCell>[
          DataCell(Text(currencyPair[i][0], textScaleFactor: 1.5)),
          DataCell(Text(currencyPair[i][1],
              textScaleFactor: 1.5,
              style: TextStyle(color: Colors.green),
              textAlign: TextAlign.right)),
          DataCell(Text(currencyPair[i][2],
              textScaleFactor: 1.5,
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.right)),
        ],
        onSelectChanged: (newValue) {
          //print('row ' + currencyPair[i][0]);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => Charts(
                  title: widget.title,
                  symbol: currencyPair[i][0],
                  value: (round_to_4(double.parse(currencyPair[i][1])) +
                      round_to_4(double.parse(currencyPair[i][2]))) /
                      2,
                ),
              ));
        },
      );
    }
  }

  void _onItemTapped(int index) {
      if(index == 1)
      {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => goldRate(),
            ));
      }
      else if(index == 2)
      {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => Convert(),
            ));
      }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    this.setTable();

    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.

          title: Row(children: <Widget>[
            Image.asset(
              'images/logobig.png',
              width: 40.0,
              height: 40.0,
            ),
            Text(widget.title),
          ]),
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Currency Exchange Rates",
                  textScaleFactor: 1,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataTable(
                // textDirection: TextDirection.rtl,
                // defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
                // border:TableBorder.all(width: 2.0,color: Colors.red),
                showCheckboxColumn: false,
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text(
                      'Symbol',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Buy',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Sell',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: rows,
              ),
            ]),
          ),
        ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset('images/dollar_world_grid_selected.png',
              width: 46.0,
              height: 46.0,
            ),
            label: 'Currency',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'images/gold-bars.png',
              width: 46.0,
              height: 46.0,
            ),
            label: 'Gold',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'images/curr_conv1.png',
              width: 46.0,
              height: 46.0,
            ),
            label: 'Convert',
          )
        ],
        currentIndex: 0,
        unselectedItemColor: Color.fromRGBO(127, 127, 127, 0.4),
        selectedItemColor: Color.fromRGBO(43, 73, 193, 0.4),
        onTap: _onItemTapped,
      ),);
  }

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(seconds: 5), (Timer t)
    {
      if (!dispos) {
        this.fetchPairValue();
      }
    });
  }

  @override
  void dispose() {
    dispos = true;
    _timer.cancel;
    super.dispose();
}
}
