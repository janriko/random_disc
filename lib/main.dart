import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random-Disc',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(title: 'Disc Of Fortune'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Disc {
  Disc(String name, bool isActive) {
    this.name = name;
    this.isActive = isActive;
  }

  String name;
  bool isActive;
}

class _MyHomePageState extends State<MyHomePage> {
  var _listOfDiscs = [
    Disc("Driver", true),
    Disc("Midrange", true),
    Disc("Putter", true),
    Disc("Ultrastar", false),
    Disc("Tennisball", false),
    Disc("Cleaning Towel", false),
    Disc("Right Shoe", false),
    Disc("Left Shoe", false)
  ];
  var _smallList = [];
  String _choosenDisc = "-";
  int _numberSelected = 3;

  final newDiscInput = TextEditingController();

  void _addNewDisc(String name) {
    setState(() {
      _listOfDiscs.add(Disc(name, true));
      _numberSelected++;
    });
  }

  void _removeNewDisc(Disc disc) {
    setState(() {
      if (disc.isActive) {
        _numberSelected--;
      }
      _listOfDiscs.remove(disc);
    });
  }

  void _spinn() {
    setState(() {
      selected = Random().nextInt(_countActiveDiscs());
      _choosenDisc = "-";
    });
  }

  void _spinnEnd() {
    setState(() {
      _choosenDisc = _smallList[selected].name;
    });
  }

  void _addToActiveList(Disc disc) {
    setState(() {
      disc.isActive = true;
      _numberSelected++;
    });
  }

  void _removeFromActiveList(Disc disc) {
    setState(() {
      disc.isActive = false;
      _numberSelected--;
    });
  }

  int _countActiveDiscs() {
    int count = 0;
    for (var disc in _listOfDiscs) {
      disc.isActive == true ? count++ : null;
    }
    return count;
  }

  List<FortuneItem> _createSmallList(List<Disc> discs) {
    List<FortuneItem> newList = [];
    List<Disc> newSmallList = [];
    for (var disc in discs) {
      if (disc.isActive) {
        newList.add(FortuneItem(child: Text(disc.name)));
        newSmallList.add(disc);
      }
    }
    _smallList = newSmallList;
    return newList;
  }

  bool deleteButtonVisibility = false;

  int selected = 0;

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(initialPage: 0);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: PageView(
          controller: controller,
          children: <Widget>[
            Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    new GestureDetector(
                        onTap: () {
                          controller.jumpToPage(1);
                        },
                        child: Container(
                            child: Column(children: [
                              Text("swipe for options"),
                              Icon(Icons.arrow_forward),
                              //Image(image: AssetImage('arrow_right.png')),
                            ], crossAxisAlignment: CrossAxisAlignment.end),
                            alignment: Alignment.centerRight)),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text(
                              'You\'ll play the next Basket with:',
                            ),
                          ),
                          Text(
                            '$_choosenDisc',
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 80),
                            child: ElevatedButton(
                              onPressed: () {
                                _spinn();
                              },
                              child: Text(
                                'Spin the wheel',
                              ),
                            ),
                          ),
                          Container(
                            height: min(MediaQuery.of(context).size.width, 500),
                            width: min(MediaQuery.of(context).size.width, 500),
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: FortuneWheel(
                                duration: Duration(seconds: 3),
                                rotationCount: 20,
                                animateFirst: false,
                                indicators: const <FortuneIndicator>[
                                  const FortuneIndicator(
                                    alignment: Alignment.topCenter,
                                    child: const TriangleIndicator(color: Color.fromARGB(255, 0, 0, 0)),
                                  ),
                                ],
                                onFling: _spinn,
                                onAnimationEnd: _spinnEnd,
                                selected: selected,
                                items: _createSmallList(_listOfDiscs),
                                styleStrategy: FortuneWheel.kDefaultStyleStrategy,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (var disc in _listOfDiscs)
                      Row(
                        children: [
                          Checkbox(
                            value: disc.isActive,
                            onChanged: (bool value) {
                              if (value) {
                                _addToActiveList(disc);
                              } else {
                                if (_numberSelected <= 2) {
                                  final snackBar = SnackBar(
                                    content: Text("You have to select at least 2"),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                } else {
                                  _removeFromActiveList(disc);
                                }
                              }
                            },
                            activeColor: Colors.orange,
                          ),
                          Text(
                            disc.name,
                            style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.black),
                          ),
                          Expanded(
                            child: IconButton(
                              alignment: Alignment.centerRight,
                              color: Colors.redAccent,
                              icon: Visibility(visible: (deleteButtonVisibility && !disc.isActive), child: Icon(Icons.delete)),
                              onPressed: () {
                                if (_listOfDiscs.length > 2) {
                                  _removeNewDisc(disc);
                                } else {
                                  final snackBar = SnackBar(
                                    content: Text("At least 2 discs need to be in the list"),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    // Text(selected.toString()),
                    // Text(_countActiveDiscs().toString())
                    Container(
                      child: TextField(
                        decoration: InputDecoration(border: OutlineInputBorder(), labelText: "Enter New Disc Name"),
                        onSubmitted: (String text) {
                          if (text.length > 0) {
                            _addNewDisc(text);
                          }
                          newDiscInput.clear();
                        },
                        controller: newDiscInput,
                        maxLength: 20,
                      ),
                      padding: EdgeInsets.only(top: 32, right: 16, left: 16, bottom: 32),
                    ),
                    FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            deleteButtonVisibility = !deleteButtonVisibility;
                          });
                        },
                        child: Icon(Icons.delete)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
