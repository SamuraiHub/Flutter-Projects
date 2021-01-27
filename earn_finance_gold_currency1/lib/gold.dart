import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main.dart' as main;
import 'dart:async';
import 'convert.dart';

class goldRate extends StatefulWidget {
  goldRate({Key key, this.title = 'We Earn Finance'}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _goldRateState createState() => _goldRateState();
}

class _goldRateState extends State<goldRate> {

  Timer _timer;
  bool dispos = false;

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

  double round_to_4(double d)
  {
    double fac = pow(10.0, 5);
    double x = d * fac/10.0;
    fac = pow(10.0, 4);
    return (x).round() / fac;
  }

  void fetchMetalValue() async {
    var response =
    await http.get('https://api.1forge.com/quotes?pairs=XAU/USD,XAU/EUR,XAU/TRY,XAG/USD,XAG/TRY,XPT/USD,XPD/USD&api_key=KatWbQa9sDFmYQ25LmtAMlGau5xKSWIe');

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      List<main.Model> list  = json.decode(response.body).map<main.Model>((data) => main.Model.fromJson(data))
          .toList();

      setState(() {

        goldPair[0][1] = round_to_4(list[0].b).toString();
        goldPair[0][2] = round_to_4(list[0].a).toString();

        goldPair[1][1] = round_to_4(list[0].b*1000.0/31.1035).toString();
        goldPair[1][2] = round_to_4(list[0].a*1000.0/31.1035).toString();

        goldPair[2][1] = round_to_4(list[1].b*1000.0/31.1035).toString();
        goldPair[2][2] = round_to_4(list[1].a*1000.0/31.1035).toString();

        goldPair[3][1] = round_to_4(list[2].b/31.1035).toString();
        goldPair[3][2] = round_to_4(list[2].a/31.1035).toString();

        goldPair[6][1] = round_to_4(list[3].b).toString();
        goldPair[6][2] = round_to_4(list[3].a).toString();

        goldPair[7][1] = round_to_4(list[4].b/31.1035).toString();
        goldPair[7][2] = round_to_4(list[4].a/31.1035).toString();

        goldPair[8][1] = round_to_4(list[5].b).toString();
        goldPair[8][2] = round_to_4(list[5].a).toString();

        goldPair[9][1] = round_to_4(list[6].b).toString();
        goldPair[9][2] = round_to_4(list[6].a).toString();

      });


    }
  }

  void fetchMetalValue4() async {
    var response = await http.get(
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
  }

  void fetchMetalValue5() async {
    var response = await http.get(
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
  }

  List<DataRow> rows = List<DataRow>(10);

  void setGoldTable() {
    for (int i = 0; i < goldPair.length; i++) {
      rows[i] = DataRow(
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

  void _onItemTapped(int index) {
    if(index == 0)
    {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => main.MyHomePage(),
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

    this.setGoldTable();

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
        body:
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
                rows: rows,
              ),
            ]),
          ),
        ),

        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Image.asset('images/dollar_world_grid.png',
                width: 46.0,
                height: 46.0,
              ),
              label: 'Currency',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'images/gold-bars-selected.png',
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
          currentIndex: 1,
          unselectedItemColor: Color.fromRGBO(127, 127, 127, 0.4),
          selectedItemColor: Color.fromRGBO(43, 73, 193, 0.4),
          onTap: _onItemTapped,
        ));
  }

  @override
  void initState() {
    super.initState();

    //Color.fromRGBO(43, 73, 193, 0.4)
    //: Color.fromRGBO(127, 127, 127, 0.4)
    _timer = Timer.periodic(Duration(seconds: 5), (Timer t)
    {
      if (!dispos) {
      this.fetchMetalValue();
      this.fetchMetalValue4();
      this.fetchMetalValue5();
    }});

  }

  @override
  void dispose() {
    dispos = true;
    _timer.cancel;
    super.dispose();
  }
}



