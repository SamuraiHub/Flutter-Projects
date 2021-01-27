import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:graphic/graphic.dart' as graphic;

import 'main.dart';
import 'gold.dart';
import 'convert.dart';

class Charts extends StatefulWidget {
  Charts({Key key, this.title = 'We Earn Finance', this.symbol, this.value}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final String symbol;
  final double value;

  @override
  _ChartsState createState() => _ChartsState();
}

class _ChartsState extends State<Charts> with SingleTickerProviderStateMixin {
  // Declare a field that holds the Todo.
  List<double> high = List.filled(7, 0.0);
  List<double> low = List.filled(7, 0.0);
  List<double> open = List.filled(7, 0.0);
  List<double> close = List.filled(7, 0.0);

  var dSortedKeys;
  var dSortedValues;

  List<Map<String, dynamic>> dData = [];

  List<Map<String, dynamic>> wData = [];

  List<Map<String, dynamic>> mData = [];

  List<Map<String, dynamic>> m6Data = [];

  List<Map<String, dynamic>> yData = [];

  List<Map<String, dynamic>> y5Data = [];

  List<Map<String, dynamic>> mxData = [];

  List<int> ms = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

  TabController _controller;
  int _selectedIndex = 0;

  List<Widget> list = [
    Tab(text: '1D'),
    Tab(text: '1W'),
    Tab(text: '1M'),
    Tab(text: '6M'),
    Tab(text: 'Y'),
    Tab(text: '5Y'),
    Tab(text: 'MX'),
  ];

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    // Create TabController for getting the index of current tab
    _controller = TabController(length: list.length, vsync: this);

    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
      });
    });

    fetchDayValues();
    fetchWeekValues();
    fetchMonthValues();
    fetch6MonthValues();
    fetchMaxValues();
  }

  void fetchDayValues() async {
    final response = await http.get(
        'https://www.alphavantage.co/query?function=FX_INTRADAY&from_symbol=' +
            widget.symbol.substring(0, 3) +
            '&to_symbol=' +
            widget.symbol.substring(4) +
            '&interval=5min&outputsize=full&apikey=NS8IP79OIRVVH7Q0');

    if (response.statusCode == 200) {
      final jsonInput = json.decode(response.body) as Map;
      final data = jsonInput["Time Series FX (5min)"] as Map;

      final sortedKeys = data.keys.toList()
        ..sort((a, b) => b.toString().compareTo(a.toString()));

      final sortedValues = sortedKeys.map((k) => data[k]["4. close"]).toList();

      int i = sortedKeys[0].toString()[sortedKeys[0].length - 4] == '5' ? 1 : 0;

      high[0] = 0;
      low[0] = 999999999.0;

      //print('size1: ' + sortedKeys.length.toString());

      setState(() {
        while (i < 288) {
          dData.insert(0, {
            'Date': sortedKeys[i].toString().substring(11, 16),
            'Close': double.parse(sortedValues[i])
          });

          high[0] = max(dData.first['Close'].toDouble(), high[0]);
          low[0] = min(dData.first['Close'].toDouble(), low[0]);

          i += 2;
        }

        open[0] = dData[0]['Close'].toDouble();
        close[0] = dData[143]['Close'].toDouble();
        //print('high: ' + high[0].toString());
        //print('low: ' + low[0].toString());
      });
    }
  }

  void fetchWeekValues() async {
    final response = await http.get(
        'https://www.alphavantage.co/query?function=FX_INTRADAY&from_symbol=' +
            widget.symbol.substring(0, 3) +
            '&to_symbol=' +
            widget.symbol.substring(4) +
            '&interval=60min&outputsize=full&apikey=NS8IP79OIRVVH7Q0');

    if (response.statusCode == 200) {
      final jsonInput = json.decode(response.body) as Map;
      final data = jsonInput["Time Series FX (60min)"] as Map;

      final sortedKeys = data.keys.toList()
        ..sort((a, b) => b.toString().compareTo(a.toString()));

      final sortedValues = sortedKeys.map((k) => data[k]["4. close"]).toList();

      int j = 0;

      high[1] = 0.0;
      low[1] = 999999999.0;

      //print('size2: ' + sortedKeys.length.toString());

      setState(() {
        while (j < 120) {
          wData.insert(0, {
            'Date': sortedKeys[j].toString().substring(0, 10),
            'Close': double.parse(sortedValues[j])
          });

          high[1] = max(wData.first['Close'].toDouble(), high[1]);
          low[1] = min(wData.first['Close'].toDouble(), low[1]);

          j++;
        }

        open[1] = wData[0]['Close'].toDouble();
        close[1] = wData[119]['Close'].toDouble();
      });
    }
  }

  void fetchMonthValues() async {
    final response = await http.get(
        'https://www.alphavantage.co/query?function=FX_INTRADAY&from_symbol=' +
            widget.symbol.substring(0, 3) +
            '&to_symbol=' +
            widget.symbol.substring(4) +
            '&interval=60min&outputsize=full&apikey=NS8IP79OIRVVH7Q0');

    if (response.statusCode == 200) {
      final jsonInput = json.decode(response.body) as Map;
      final data = jsonInput["Time Series FX (60min)"] as Map;

      final sortedKeys = data.keys.toList()
        ..sort((a, b) => b.toString().compareTo(a.toString()));

      final sortedValues = sortedKeys.map((k) => data[k]["4. close"]).toList();

      int j = 0;

      //2020-10-26 16:00:00
      String m1 = sortedKeys[0].toString().substring(5, 7);
      String m2 = sortedKeys[0].toString().substring(5, 7);
      String d1 = sortedKeys[0].toString().substring(8, 10);
      String d2 = sortedKeys[0].toString().substring(8, 10);
      String h1 = sortedKeys[0].toString().substring(11, 13);
      String h2 = sortedKeys[0].toString().substring(11, 13);

      high[2] = 0.0;
      low[2] = 999999999.0;

      //print('size3: ' + sortedKeys.length.toString());

      int x = int.parse(m2)-1;
      String ms1 = x > 0 ? x.toString() : '12';

      setState(() {
        while (m2 == m1 || (ms1 == m2 && d2.compareTo(d1) > 0) || (h2.compareTo(h1) >= 0)) {
          mData.insert(0, {
            'Date': sortedKeys[j].toString().substring(0, 10),
            'Close': double.parse(sortedValues[j])
          });

          high[2] = max(mData.first['Close'].toDouble(), high[2]);
          low[2] = min(mData.first['Close'].toDouble(), low[2]);

          j += 4;
          m2 = sortedKeys[j].toString().substring(5, 7);
          d2 = sortedKeys[j].toString().substring(8, 10);
          h2 = sortedKeys[j].toString().substring(11, 13);
        }

        open[2] = mData[0]['Close'].toDouble();
        close[2] = mData[mData.length - 1]['Close'].toDouble();
      });
    }
  }

  void fetch6MonthValues() async {
    final response = await http.get(
        'https://www.alphavantage.co/query?function=FX_DAILY&from_symbol=' +
            widget.symbol.substring(0, 3) +
            '&to_symbol=' +
            widget.symbol.substring(4) +
            '&outputsize=full&apikey=NS8IP79OIRVVH7Q0');

    if (response.statusCode == 200) {
      final jsonInput = json.decode(response.body) as Map;
      final data = jsonInput["Time Series FX (Daily)"] as Map;

      dSortedKeys = data.keys.toList()
        ..sort((a, b) => b.toString().compareTo(a.toString()));

      dSortedValues = dSortedKeys.map((k) => data[k]["4. close"]).toList();

      int j = 0;

      //2020-10-26
      int m1 = int.parse(dSortedKeys[0].toString().substring(5, 7));
      int m2 = int.parse(dSortedKeys[0].toString().substring(5, 7));
      int x = m1 - 6;
      if (m1 <= 6) x = 12 + x;

      String d1 = dSortedKeys[0].toString().substring(8, 10);
      String d2 = dSortedKeys[0].toString().substring(8, 10);

      high[3] = 0.0;
      low[3] = 999999999.0;

      //print('size4: ' + dSortedKeys.length.toString());

      setState(() {
        while (m2 != x || (m2 == x && d2.compareTo(d1) > 0)) {
          m6Data.insert(0, {
            'Date': dSortedKeys[j],
            'Close': double.parse(dSortedValues[j])
          });

          high[3] = max(m6Data.first['Close'].toDouble(), high[3]);
          low[3] = min(m6Data.first['Close'].toDouble(), low[3]);

          j++;
          m2 = int.parse(dSortedKeys[j].toString().substring(5, 7));
          d2 = dSortedKeys[j].toString().substring(8, 10);
        }

        m6Data.insert(0, {
          'Date': dSortedKeys[j],
          'Close': double.parse(dSortedValues[j])
        });

        high[3] = max(m6Data.first['Close'].toDouble(), high[3]);
        low[3] = min(m6Data.first['Close'].toDouble(), low[3]);

        open[3] = m6Data[0]['Close'].toDouble();
        close[3] = m6Data[m6Data.length - 1]['Close'].toDouble();
      });

      fetchYearValues();
      fetch5YearValues();
    }
  }

  void fetchYearValues() {
    int j = 0;

    //2020-10-26
    String y1 = dSortedKeys[0].toString().substring(0, 4);
    String y2 = dSortedKeys[0].toString().substring(0, 4);

    String m1 = dSortedKeys[0].toString().substring(5, 7);
    String m2 = dSortedKeys[0].toString().substring(5, 7);

    String d1 = dSortedKeys[0].toString().substring(8, 10);
    String d2 = dSortedKeys[0].toString().substring(8, 10);

    high[4] = 0.0;
    low[4] = 999999999.0;

    String y3 = (int.parse(y2)-1).toString();

    setState(() {
      while (y1 == y2 || (y2 == y3 && m2.compareTo(m1) > 0) || (m2 == m1 && d2.compareTo(d1) > 0)) {
        yData.insert(0,
            {'Date': dSortedKeys[j], 'Close': double.parse(dSortedValues[j])});

        high[4] = max(yData.first['Close'].toDouble(), high[4]);
        low[4] = min(yData.first['Close'].toDouble(), low[4]);

        j += 2;
        y2 = dSortedKeys[j].toString().substring(0, 4);
        m2 = dSortedKeys[j].toString().substring(5, 7);
        d2 = dSortedKeys[j].toString().substring(8, 10);
      }

      yData.insert(0,
          {'Date': dSortedKeys[j], 'Close': double.parse(dSortedValues[j])});

      high[4] = max(yData.first['Close'].toDouble(), high[4]);
      low[4] = min(yData.first['Close'].toDouble(), low[4]);

      open[4] = yData[0]['Close'].toDouble();
      close[4] = yData[yData.length - 1]['Close'].toDouble();
    });
  }

  void fetch5YearValues() {
    int j = 0;

    //2020-10-26
    int y2 = int.parse(dSortedKeys[0].toString().substring(0, 4));
    int x = y2 - 5;

    String m1 = dSortedKeys[0].toString().substring(5, 7);
    String m2 = dSortedKeys[0].toString().substring(5, 7);

    String d1 = dSortedKeys[0].toString().substring(8, 10);
    String d2 = dSortedKeys[0].toString().substring(8, 10);

    high[5] = 0;
    low[5] = 999999999;

    print("year: "+x.toString() + " Month: "+ m1 + "Day: " + d1);

    setState(() {
      while (y2 > x || (y2 == x && m2.compareTo(m1) > 0) || (m2 == m1 && d2.compareTo(d1) > 0)) {
        y5Data.insert(0,
            {'Date': dSortedKeys[j], 'Close': double.parse(dSortedValues[j])});

        high[5] = max(y5Data.first['Close'].toDouble(), high[5]);
        low[5] = min(y5Data.first['Close'].toDouble(), low[5]);

        j += 10;
        y2 = int.parse(dSortedKeys[j].toString().substring(0, 4));
        m2 = dSortedKeys[j].toString().substring(5, 7);
        d2 = dSortedKeys[j].toString().substring(8, 10);
        print("year: "+y2.toString() + " Month: "+ m2 + "Day: " + d2);
      }

      y5Data.insert(0,
          {'Date': dSortedKeys[j], 'Close': double.parse(dSortedValues[j])});

      high[5] = max(y5Data.first['Close'].toDouble(), high[5]);
      low[5] = min(y5Data.first['Close'].toDouble(), low[5]);

      open[5] = y5Data[0]['Close'].toDouble();
      close[5] = y5Data[y5Data.length - 1]['Close'].toDouble();
    });
  }

  void fetchMaxValues() async {
    final response = await http.get(
        'https://www.alphavantage.co/query?function=FX_MONTHLY&from_symbol=' +
            widget.symbol.substring(0, 3) +
            '&to_symbol=' +
            widget.symbol.substring(4) +
            '&apikey=NS8IP79OIRVVH7Q0');

    if (response.statusCode == 200) {
      final jsonInput = json.decode(response.body) as Map;
      final data = jsonInput["Time Series FX (Monthly)"] as Map;

      final sortedKeys = data.keys.toList()
        ..sort((a, b) => b.toString().compareTo(a.toString()));

      final sortedValues = sortedKeys.map((k) => data[k]["4. close"]).toList();

      double x = sortedKeys.length / 120.0;

      x = x + 0.4;

      int y = x.toInt();

      high[6] = 0;
      low[6] = 999999999;

      //print('size5: ' + sortedKeys.length.toString());

      setState(() {
        for (int j = 0; j < sortedKeys.length; j += y) {
          mxData.insert(0,
              {'Date': sortedKeys[j], 'Close': double.parse(sortedValues[j])});

          high[6] = max(mxData.first['Close'].toDouble(), high[6]);
          low[6] = min(mxData.first['Close'].toDouble(), low[6]);
        }

        open[6] = mxData[0]['Close'].toDouble();
        close[6] = mxData[mxData.length - 1]['Close'].toDouble();
      });
    }
  }

  Widget displayChart(List<Map<String, dynamic>> data, double low, double high,
      double open, double close, String symbol, String interval) {
    if (data.isEmpty) return SizedBox.shrink();

    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: <Widget>[

            Padding(child: Text(widget.symbol + ": " + widget.value.toString(),
                style: TextStyle(fontSize: 20)),
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),),

            Padding(
              child: Text(symbol + " " + interval + " Chart",
                  style: TextStyle(fontSize: 20)),
              padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
            ),
            Container(
              width: 400,
              height: 350,
              child: graphic.Chart(
                data: data,
                scales: {
                  'Date': graphic.CatScale(
                    accessor: (map) => map['Date'] as String,
                    range: [0, 0.94],
                    tickCount: 6,
                  ),
                  'Close': graphic.LinearScale(
                    accessor: (map) => map['Close'] as num,
                    nice: true,
                    min: ((low * 100).toInt()) / 100.0,
                  )
                },
                geoms: [
                  graphic.AreaGeom(
                    position: graphic.PositionAttr(field: 'Date*Close'),
                    shape: graphic.ShapeAttr(
                        values: [graphic.BasicAreaShape(smooth: true)]),
                    color: graphic.ColorAttr(values: [
                      graphic.Defaults.theme.colors.first.withAlpha(80),
                    ]),
                  ),
                  graphic.LineGeom(
                    position: graphic.PositionAttr(field: 'Date*Close'),
                    shape: graphic.ShapeAttr(
                        values: [graphic.BasicLineShape(smooth: true)]),
                    size: graphic.SizeAttr(values: [0.5]),
                  ),
                ],
                axes: {
                  'Date': graphic.Defaults.horizontalAxis,
                  'Close': graphic.Defaults.verticalAxis,
                },
              ),
            ),
            DataTable(
              columns: [
                DataColumn(
                  label: Text(""),
                ),
                DataColumn(
                  label: Text(""),
                ),
              ],
              rows: <DataRow>[
                DataRow(
                  cells: <DataCell>[
                    DataCell(
                      Text(
                        'High\n' + high.toString(),
                        textScaleFactor: 1.5,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    DataCell(Text('Low\n' + low.toString(),
                        textScaleFactor: 1.5, textAlign: TextAlign.center)),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('Open\n' + open.toString(),
                        textScaleFactor: 1.5, textAlign: TextAlign.center)),
                    DataCell(
                      Text('Close\n' + close.toString(),
                          textScaleFactor: 1.5, textAlign: TextAlign.center),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {

    if(index == 0)
    {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => MyHomePage(),
          ));
    }
    else if(index == 1)
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
    // Use the Todo to create the UI.

    return WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacement(context,
              new MaterialPageRoute(builder: (context) => MyHomePage()));

          return true;
        },
        child: Scaffold(
          appBar:
             AppBar(
              title:
                Row(children: <Widget>[
                  Image.asset(
                    'images/logobig.png',
                    width: 40.0,
                    height: 40.0,
                  ),
                  Text(widget.title),
                ]),

              leading: new IconButton(
                icon: new Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => MyHomePage()));
                },
              ),
              backgroundColor: Colors.blue,
              bottom: TabBar(
                controller: _controller,
                isScrollable: true,
                tabs: list,
              ),
            ),

          backgroundColor: Colors.white,
          body: TabBarView(
            controller: _controller,
            children: [
              displayChart(dData, low[0], high[0], open[0], close[0],
                  widget.symbol, "1 Day"),
              displayChart(wData, low[1], high[1], open[1], close[1],
                  widget.symbol, "1 Week"),
              displayChart(mData, low[2], high[2], open[2], close[2],
                  widget.symbol, "1 Month"),
              displayChart(m6Data, low[3], high[3], open[3], close[3],
                  widget.symbol, "6 Month"),
              displayChart(yData, low[4], high[4], open[4], close[4],
                  widget.symbol, "1 Year"),
              displayChart(y5Data, low[5], high[5], open[5], close[5],
                  widget.symbol, "5 Year"),
              displayChart(mxData, low[6], high[6], open[6], close[6],
                  widget.symbol, "Max")
            ],
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
    )
        ));
  }
}
