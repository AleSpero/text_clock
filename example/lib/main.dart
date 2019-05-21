import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:text_clock/text_clock.dart';
import 'package:timezone/timezone.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    loadTimezoneData().then((rawData){
      initializeDatabase(rawData);
      debugPrint("Timezone database initialized.");
    });

    return MaterialApp(
      title: 'TextClock Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'TextClock Demo'),
    );
  }

  //Only for timezone support
  Future<List<int>> loadTimezoneData() async {
    var byteData = await rootBundle.load("assets/other/2018i_2010-2020.tzf");
    return byteData.buffer.asUint8List();
  }

}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
          buildCard(),
          buildCard(),
          buildCard()
        ],) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


  Widget buildCard({String timezone}){
    return Center(child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Container(padding: EdgeInsets.all(20),child: Column(children: <Widget>[
          TextClock(), Text("Milan")
        ]))));
  }

}
