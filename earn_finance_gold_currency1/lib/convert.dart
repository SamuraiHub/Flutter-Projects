import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:graphic/graphic.dart' as graphic;

import 'main.dart';
import 'gold.dart';

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:graphic/graphic.dart' as graphic;

import 'main.dart';
import 'gold.dart';

class Model {
  final double p;
  final String s;

  Model._({this.p, this.s});

  factory Model.fromJson(Map<String, dynamic> json) {
    return new Model._(
      p: json['p'],
      s: json['s'],
    );
  }
}

class Convert extends StatefulWidget {
  Convert({Key key, this.title = 'We Earn Finance'}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _ConvertState createState() => _ConvertState();
}

class _ConvertState extends State<Convert>  with SingleTickerProviderStateMixin
{
  List<String> currencies = [
    "USD", "EUR", "TRY", 'CAD', 'GBP', 'AUD', 'JPY', 'CHF', 'AED', 'QAR', 'BGN', 'DKK', 'SAR', 'CNY', 'RUB', 'NOK', 'SEK'
  ];

  List<String> metals = [
    "Gold (oz)", "Gold (gram)", "Gold (kg)", "Gold 14k (oz)", "Gold 22k (oz)", "Silver (oz)", "Silver (gram)", "Silver (kg)" ,
    "Platinum (oz)", "Platinum (gram)", "Platinum (kg)", "Palladium (oz)", "Palladium (gram)", "Palladium (kg)"
  ];

  List<String> metalCurr = [
    "USD", "EUR", "TRY"
  ];

  List<double> goldPrice = [
    1.0, //usd to usd
    0.0, //usd to eur
    0.0, //usd to try
    0.0, //gold (oz) to usd
    0.0, //gold (gram) to usd
    0.0,  //gold (kg) to usd
    0.0,  //gold 14k (oz) to usd
    0.0, //gold  22k (oz) to usd
    0.0, //silver (oz) to usd
    0.0, //silver (gram) to usd
    0.0, //silver (kg) to usd
    0.0, //plt (oz) to usd
    0.0, //plt (gram) to usd
    0.0, //plt (kg) to usd
    0.0, //pld (oz) to usd
    0.0, //pld (gram) to usd
    0.0, //pld (kg) to usd
  ];


  String selectedCurrency1;
  String selectedCurrency2;
  int selectedMetal1;
  int selectedCurrency3;
  double price;
  TextEditingController _controller1 = new TextEditingController();
  TextEditingController _controller2 = new TextEditingController();
  TextEditingController _controller3 = new TextEditingController();
  TextEditingController _controller4 = new TextEditingController();

  TabController _controller;

  double round_to_2(double d)
  {
    double fac = pow(10.0, 3);
    double x = d * fac/10.0;
    fac = pow(10.0, 2);
    return (x).round() / fac;
  }

  onChangeDropdownItem1(String selectedCurrency) {

    selectedCurrency1 = selectedCurrency;
    if(selectedCurrency1 != selectedCurrency2)
    {
      fetchPairValue();
    }
    else {
      setState(() {
        price = 1.00;
        _controller1.text = '1.00';
        _controller2.text = '1.00';
      });
    }
  }

  onChangeDropdownItem2(String selectedCurrency) {
    setState(() {
      selectedCurrency2 = selectedCurrency;
      if(selectedCurrency1 != selectedCurrency2)
      {
        fetchPairValue();
      }
      else {
        setState(() {
          price = 1.00;
          _controller1.text = '1.00';
          _controller2.text = '1.00';
        });
      }
    });
  }

  onChangeDropdownItem3(String selectedMetal) {

    selectedMetal1 = metals.indexOf(selectedMetal);

      setState(() {
        _controller3.text = '1.00';
        _controller4.text = round_to_2(goldPrice[selectedMetal1+3]*goldPrice[selectedCurrency3]).toString();
      });
  }

  onChangeDropdownItem4(String selectedCurrency) {

    selectedCurrency3 = metalCurr.indexOf(selectedCurrency);

      setState(() {
        _controller3.text = '1.00';
        _controller4.text = round_to_2(goldPrice[selectedMetal1+3]*goldPrice[selectedCurrency3]).toString();
      });
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
  }

  void fetchMetalValue() async {
    var response =
    await http.get('https://api.1forge.com/quotes?pairs=USD/EUR,USD/TRY,XAU/USD,XAG/USD,XPT/USD,XPD/USD&api_key=KatWbQa9sDFmYQ25LmtAMlGau5xKSWIe');

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      List<Model> list  = json.decode(response.body).map<Model>((data) => Model.fromJson(data))
          .toList();

      setState(() {

        goldPrice[1] = round_to_2(list[0].p); // usd to eur
        goldPrice[2] = round_to_2(list[1].p); //usd to try

        goldPrice[3] = round_to_2(list[2].p);
        goldPrice[4] = round_to_2(list[2].p/31.1035);
        goldPrice[5] = round_to_2(list[2].p*1000.0/31.1035);

        goldPrice[8] = round_to_2(list[3].p);
        goldPrice[9] = round_to_2(list[3].p/31.1035);
        goldPrice[10] = round_to_2(list[3].p*1000.0/31.1035);

        goldPrice[11] = round_to_2(list[4].p);
        goldPrice[12] = round_to_2(list[4].p/31.1035);
        goldPrice[13] = round_to_2(list[4].p*1000.0/31.1035);

        goldPrice[14] = round_to_2(list[5].p);
        goldPrice[15] = round_to_2(list[5].p/31.1035);
        goldPrice[16] = round_to_2(list[5].p*1000.0/31.1035);

        _controller3.text = '1.00';
        _controller4.text = (round_to_2(goldPrice[selectedMetal1+3]*goldPrice[selectedCurrency3])).toString();
      });

    }
  }

  void fetchMetalValue6() async {
    var response = await http.get(
        'https://www.goldrate24.com/gold-prices/north-america/united_states/ounce/14K/');

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON

      String htmlToParse = response.body;
      int idx1 = htmlToParse.indexOf("Current Rate") + 21; //Current Rate</td><td>

      int idx3 = htmlToParse.indexOf(" ", idx1);

      setState(() {
        goldPrice[6] = round_to_2(double.parse(htmlToParse.substring(idx1, idx3).replaceAll(',', "")));
      });
    }
  }

  void fetchMetalValue7() async {
    var response = await http.get(
        'https://www.goldrate24.com/gold-prices/north-america/united_states/ounce/22K/');

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON

      String htmlToParse = response.body;
      int idx1 = htmlToParse.indexOf("Current Rate") + 21;

      int idx3 = htmlToParse.indexOf(" ", idx1);

      setState(() {
        goldPrice[7] = round_to_2(double.parse(htmlToParse.substring(idx1, idx3).replaceAll(',', "")));
      });
    }
  }

  void fetchPairValue() async
  {
    final response = await http.get('https://www.currencyconverterrate.com/' +
        selectedCurrency1.toLowerCase() +
        '/' +
        selectedCurrency2.toLowerCase() +
        '.html');

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON

      String htmlToParse = response.body;
      int idx1 = htmlToParse.indexOf("Bid Price") + 11; //
      int idx2 = htmlToParse.indexOf("Ask Price", idx1) + 11;

      int idx3 = htmlToParse.indexOf("<", idx1);
      int idx4 = htmlToParse.indexOf("<", idx2);

      setState(() {
        price = round_to_2((double.parse(htmlToParse.substring(idx1, idx3)) + double.parse(htmlToParse.substring(idx2, idx4)))/2.0);
        _controller1.text = '1.00';
        _controller2.text = price.toString();
      });
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  @override
  void initState()
  {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
    selectedCurrency1 = "USD";
    selectedCurrency2 = "EUR";
    selectedMetal1 = 0;
    selectedCurrency3 = 0;
    fetchPairValue();
    fetchMetalValue();
    fetchMetalValue6();
    fetchMetalValue7();
  }

  onFieldChanged1(String value)
  {
    setState(() {
      _controller2.text = round_to_2(price*double.parse(value)).toString();
    });
  }

  onFieldChanged2(String value)
  {
    setState(() {
    _controller1.text = round_to_2(double.parse(value)/price).toString();
    });
  }

  onFieldChanged3(String value)
  {
    setState(() {
      _controller4.text = round_to_2(goldPrice[selectedMetal1+3]*goldPrice[selectedCurrency3]*double.parse(value)).toString();
    });
  }

  onFieldChanged4(String value)
  {
    setState(() {
      _controller3.text = round_to_2(double.parse(value)/(goldPrice[selectedMetal1+3]*goldPrice[selectedCurrency3])).toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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

          bottom: TabBar(
            controller: _controller,
            isScrollable: true,
            tabs: [Tab(text:"Currency",), Tab(text:"Gold",)],
          )
      ),
      body:  TabBarView(
          controller: _controller,
          children: [Column(children: <Widget>[

            Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Currency Conversion",
                textScaleFactor: 1.5,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )),

            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Container(
          width: 150,
            child: Text(
            "Select First Symbol",
            textScaleFactor: 1,
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
        Container(
            width: 150,
            child:
              Text(
                "Select Second Symbol",
                textScaleFactor: 1,
                style: TextStyle(fontWeight: FontWeight.bold),
              ))]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Container(
        width: 150,
        child: DropdownButton(
            value: selectedCurrency1,
            onChanged: (newValue) {
              onChangeDropdownItem1(newValue);
            },
            items: currencies.map((currency) {
              return DropdownMenuItem(
                child: Text(currency, textScaleFactor: 1),
                value: currency,
              );
            }).toList(),)),
    Container(
    width: 150,
      child: DropdownButton(
            value: selectedCurrency2,
            onChanged: (newValue) {
              onChangeDropdownItem2(newValue);
            },
            items: currencies.map((currency) {
              return DropdownMenuItem(
                child: Text(currency, textScaleFactor: 1),
                value: currency,
              );
            }).toList(),))]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Container(
        width: 150, // do it in both Container
    child:
          TextFormField(keyboardType: TextInputType.numberWithOptions(decimal: true),
                    controller: _controller1,
                    onChanged:(value) {
                      onFieldChanged1(value);
                    }, )),
    Container(
    width: 150, // do it in both Container
    child:
    TextFormField(keyboardType: TextInputType.numberWithOptions(decimal: true),
                    controller: _controller2,
                    onChanged: (value) {
                      onFieldChanged2(value);
                    }, ))
        ],)
          ]),

            Column(children: <Widget>[

              Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Gold Conversion",
                      textScaleFactor: 1.5,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )),

              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Container(
                    width: 150,
                    child: Text(
                      "Select Metal",
                      textScaleFactor: 1,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Container(
                    width: 150,
                    child:
                    Text(
                      "Select Currency",
                      textScaleFactor: 1,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Container(
                    width: 150,
                    child: DropdownButton(
                      value: metals[selectedMetal1],
                      onChanged: (newValue) {
                        onChangeDropdownItem3(newValue);
                      },
                      items: metals.map((currency) {
                        return DropdownMenuItem(
                          child: new Text(currency, textScaleFactor: 1),
                          value: currency,
                        );
                      }).toList(),)),
                Container(
                    width: 150,
                    child: DropdownButton(
                      value: metalCurr[selectedCurrency3],
                      onChanged: (newValue) {
                        onChangeDropdownItem4(newValue);
                      },
                      items: metalCurr.map((currency) {
                        return DropdownMenuItem(
                          child: new Text(currency, textScaleFactor: 1),
                          value: currency,
                        );
                      }).toList(),))]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Container(
                    width: 150, // do it in both Container
                    child:
                    TextFormField(keyboardType: TextInputType.numberWithOptions(decimal: true),
                      controller: _controller3,
                      onChanged:(value) {
                        onFieldChanged3(value);
                      }, )),
                Container(
                    width: 150, // do it in both Container
                    child:
                    TextFormField(keyboardType: TextInputType.numberWithOptions(decimal: true),
                      controller: _controller4,
                      onChanged: (value) {
                        onFieldChanged4(value);
                      }, ))
              ],)
            ])

          ]),

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
              'images/gold-bars.png',
              width: 46.0,
              height: 46.0,
            ),
            label: 'Gold',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'images/curr_conv1_selected.png',
              width: 46.0,
              height: 46.0,
            ),
            label: 'Convert',
          )
        ],
        currentIndex: 2,
        unselectedItemColor: Color.fromRGBO(127, 127, 127, 0.4),
        selectedItemColor: Color.fromRGBO(43, 73, 193, 0.4),
        onTap: _onItemTapped,
      ),);
  }
}