import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'charts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
      home: MyHomePage(title: 'We Earn Finance', p_idx: 0),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage(
      {Key key = const Key("any_key"),
      this.title = 'We Earn Finance',
      this.p_idx = 0})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final int p_idx;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  List<List<String>> currencyPair = [
    ["EUR-USD", "0", "0"],
    ["USD-TRY", "0", "0"],
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

  List<List<String>> goldPair = [
    ["GOLD-USD (OZ)", "0", "0"],
    ["GOLD-USD (KG)", "0", "0"],
    ['GOLD-EUR (KG)', "0", "0"],
    ['GOLD-TRY (Gram)', "0", "0"],
    ['GOLD(14K)-USD (OZ)', "0", "0"],
    ['GOLD(22K)-USD (OZ)', "0", "0"],
    ['SLIVER-USD (OZ)', "0", "0"],
    ['SLIVER-TRY (Gram)', "0", "0"],
    ['PLATINUM-USD (OZ)', "0", "0"],
    ['PALLADIUM-USD (OZ)', "0", "0"]
  ];

  late TabController _controller;
  int _selectedIndex = 0;

  List<Widget> list = [
    Tab(
      icon: Image.asset(
        'images/dollar_world_grid_selected.png',
        width: 46.0,
        height: 46.0,
      ),
      child: Text(
        "Currency",
        style: TextStyle(color: Color.fromRGBO(43, 73, 193, 0.4)),
      ),
    ),
    Tab(
        icon: Image.asset(
          'images/gold-bars.png',
          width: 46.0,
          height: 46.0,
        ),
        child: Text(
          "Gold",
          style: TextStyle(color: Color.fromRGBO(127, 127, 127, 0.4)),
        )),
  ];

  int ct = 0;

  void fetchPairValue() async {
    for (int i = 0; i < currencyPair.length; i++) {
      String c = currencyPair[i][0].toLowerCase();
      final response = await http.get('https://www.currencyconverterrate.com/' +
          c.substring(0, 3) +
          '/' +
          c.substring(4) +
          '.html');

      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON

        String htmlToParse = response.body;
        int idx1 = htmlToParse.indexOf("Bid Price") + 11; //
        int idx2 = htmlToParse.indexOf("Ask Price", idx1) + 11;

        int idx3 = htmlToParse.indexOf("<", idx1);
        int idx4 = htmlToParse.indexOf("<", idx2);

        setState(() {
          currencyPair[i][1] = htmlToParse.substring(idx1, idx3);
          currencyPair[i][2] = htmlToParse.substring(idx2, idx4);
        });
      } else {
        // If that call was not successful, throw an error.
        throw Exception('Failed to load post');
      }
    }
  }

  void fetchMetalValue() async {
    var response =
        await http.get('https://www.investing.com/currencies/xau-usd');

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON

      String htmlToParse = response.body;
      int idx1 = htmlToParse.indexOf("bid\">") + 5; //
      int idx2 = htmlToParse.indexOf("ask\">", idx1) + 5;

      int idx3 = htmlToParse.indexOf("<", idx1);
      int idx4 = htmlToParse.indexOf("<", idx2);

      setState(() {
        goldPair[0][1] = htmlToParse.substring(idx1, idx3);
        goldPair[0][2] = htmlToParse.substring(idx2, idx4);
      });
    }

    response =
        await http.get('https://www.monex.com/1-kilo-gold-bars-for-sale/');

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON

      String htmlToParse = response.body;
      int idx1 = htmlToParse.indexOf("bid\">") + 6; //
      int idx2 = htmlToParse.indexOf("ask\">", idx1) + 6;

      int idx3 = htmlToParse.indexOf("<", idx1);
      int idx4 = htmlToParse.indexOf("<", idx2);

      setState(() {
        goldPair[1][1] = htmlToParse.substring(idx1, idx3);
        goldPair[1][2] = htmlToParse.substring(idx2, idx4);
      });
    }

    response = await http
        .get('http://www.livepriceofgold.com/eur-gold-price-per-kilo.html');

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON

      String htmlToParse = response.body;
      int idx1 = htmlToParse.indexOf("KG in EUR") + 18; //KG in EUR</td><td>
      int idx2 = htmlToParse.indexOf("</td><td>", idx1) + 9;

      int idx3 = htmlToParse.indexOf("<", idx1);
      int idx4 = htmlToParse.indexOf("<", idx2);

      setState(() {
        goldPair[2][1] = htmlToParse.substring(idx1, idx3);
        goldPair[2][2] = htmlToParse.substring(idx2, idx4);
      });
    }

    response = await http.get('https://www.investing.com/currencies/gau-try');

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON

      String htmlToParse = response.body;
      int idx1 = htmlToParse.indexOf("bid\">") + 5;
      int idx2 = htmlToParse.indexOf("ask\">", idx1) + 5;

      int idx3 = htmlToParse.indexOf("<", idx1);
      int idx4 = htmlToParse.indexOf("<", idx2);

      setState(() {
        goldPair[3][1] = htmlToParse.substring(idx1, idx3);
        goldPair[3][2] = htmlToParse.substring(idx2, idx4);
      });
    }

    response = await http.get(
        'https://www.goldrate24.com/gold-prices/north-america/united_states/ounce/14K/');

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON

      String htmlToParse = response.body;
      int idx1 = htmlToParse.indexOf("Bid Price") + 18; //Bid Price</td><td>
      int idx2 = htmlToParse.indexOf("Ask Price", idx1) + 18;

      int idx3 = htmlToParse.indexOf(" ", idx1);
      int idx4 = htmlToParse.indexOf(" ", idx2);

      setState(() {
        goldPair[4][1] = htmlToParse.substring(idx1, idx3);
        goldPair[4][2] = htmlToParse.substring(idx2, idx4);
      });
    }

    response = await http.get(
        'https://www.goldrate24.com/gold-prices/north-america/united_states/ounce/22K/');

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON

      String htmlToParse = response.body;
      int idx1 = htmlToParse.indexOf("Bid Price") + 18; //
      int idx2 = htmlToParse.indexOf("Ask Price", idx1) + 18;

      int idx3 = htmlToParse.indexOf(" ", idx1);
      int idx4 = htmlToParse.indexOf(" ", idx2);

      setState(() {
        goldPair[5][1] = htmlToParse.substring(idx1, idx3);
        goldPair[5][2] = htmlToParse.substring(idx2, idx4);
      });
    }

    response = await http.get('https://www.investing.com/currencies/xag-usd');

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON

      String htmlToParse = response.body;
      int idx1 = htmlToParse.indexOf("bid\">") + 5; //
      int idx2 = htmlToParse.indexOf("ask\">", idx1) + 5;

      int idx3 = htmlToParse.indexOf("<", idx1);
      int idx4 = htmlToParse.indexOf("<", idx2);

      setState(() {
        goldPair[6][1] = htmlToParse.substring(idx1, idx3);
        goldPair[6][2] = htmlToParse.substring(idx2, idx4);
      });
    }

    response = await http.get('https://www.investing.com/currencies/xagg-try');

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON

      String htmlToParse = response.body;
      int idx1 = htmlToParse.indexOf("bid\">") + 5; //
      int idx2 = htmlToParse.indexOf("ask\">", idx1) + 5;

      int idx3 = htmlToParse.indexOf("<", idx1);
      int idx4 = htmlToParse.indexOf("<", idx2);

      setState(() {
        goldPair[7][1] = htmlToParse.substring(idx1, idx3);
        goldPair[7][2] = htmlToParse.substring(idx2, idx4);
      });
    }

    response = await http.get('https://www.investing.com/currencies/xpt-usd');

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON

      String htmlToParse = response.body;
      int idx1 = htmlToParse.indexOf("bid\">") + 5; //
      int idx2 = htmlToParse.indexOf("ask\">", idx1) + 5;

      int idx3 = htmlToParse.indexOf("<", idx1);
      int idx4 = htmlToParse.indexOf("<", idx2);

      setState(() {
        goldPair[8][1] = htmlToParse.substring(idx1, idx3);
        goldPair[8][2] = htmlToParse.substring(idx2, idx4);
      });
    }

    response = await http.get('https://www.investing.com/currencies/xpd-usd');

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON

      String htmlToParse = response.body;
      int idx1 = htmlToParse.indexOf("bid\">") + 5; //
      int idx2 = htmlToParse.indexOf("ask\">", idx1) + 5;

      int idx3 = htmlToParse.indexOf("<", idx1);
      int idx4 = htmlToParse.indexOf("<", idx2);

      setState(() {
        goldPair[9][1] = htmlToParse.substring(idx1, idx3);
        goldPair[9][2] = htmlToParse.substring(idx2, idx4);
      });
    }
  }

  List<DataRow> rows = List.filled(17, DataRow(cells: <DataCell>[]));

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
                  value: (double.parse(currencyPair[i][1]) +
                          double.parse(currencyPair[i][2])) /
                      2,
                ),
              ));
        },
      );
    }
  }

  List<DataRow> rows1 = List.filled(10, DataRow(cells: <DataCell>[]));

  void setGoldTable() {
    for (int i = 0; i < goldPair.length; i++) {
      rows1[i] = DataRow(
        cells: <DataCell>[
          DataCell(Text(goldPair[i][0], textScaleFactor: 1.5)),
          DataCell(Text(goldPair[i][1],
              textScaleFactor: 1.5,
              style: TextStyle(color: Colors.green),
              textAlign: TextAlign.right)),
          DataCell(Text(goldPair[i][2],
              textScaleFactor: 1.5,
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.right)),
        ],
      );
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
    this.setGoldTable();
    return DefaultTabController(
        initialIndex: widget.p_idx,
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.

              title: Row(children: <Widget>[
                Image.asset(
                  'images/logobig.png',
                  width: 50.0,
                  height: 50.0,
                ),
                Text(widget.title),
              ]),
              backgroundColor: Colors.blue,
            ),
            body: TabBarView(controller: _controller, children: [
              SingleChildScrollView(
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Gold Exchange Rates",
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
                      rows: rows1,
                    ),
                  ]),
                ),
              ),
            ]),
            bottomNavigationBar: Material(
                color: Colors.white,
                child: TabBar(
                  controller: _controller,
                  indicatorColor: Color.fromRGBO(43, 73, 193, 0.4),
                  tabs: list,
                ))));
  }

  @override
  void initState() {
    super.initState();

    // Create TabController for getting the index of current tab
    _controller = TabController(length: list.length, vsync: this);

    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;

        list = [
          Tab(
            icon: Image.asset(
              _selectedIndex == 0
                  ? 'images/dollar_world_grid_selected.png'
                  : 'images/dollar_world_grid.png',
              width: 46.0,
              height: 46.0,
            ),
            child: Text(
              "Currency",
              style: TextStyle(
                  color: _selectedIndex == 0
                      ? Color.fromRGBO(43, 73, 193, 0.4)
                      : Color.fromRGBO(127, 127, 127, 0.4)),
            ),
          ),
          Tab(
              icon: Image.asset(
                _selectedIndex == 1
                    ? 'images/gold-bars-selected.png'
                    : 'images/gold-bars.png',
                width: 46.0,
                height: 46.0,
              ),
              child: Text(
                "Gold",
                style: TextStyle(
                    color: _selectedIndex == 1
                        ? Color.fromRGBO(43, 73, 193, 0.4)
                        : Color.fromRGBO(127, 127, 127, 0.4)),
              )),
        ];
      });
    });

    this.fetchPairValue();
    this.fetchMetalValue();
  }
}
