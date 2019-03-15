import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:saramad_houshmand/style/theme.dart' as Theme;
import 'package:saramad_houshmand/qr_add/qr_add.dart' as qr_add;
import 'package:saramad_houshmand/qr_add/qr_reader.dart' as qr_reader;
import 'package:saramad_houshmand/mqtt/mqtt_pub.dart' as mqtt;

final String ip = "http://192.168.1.1/Devices/DataToJson.php";
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "MainPage",
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: MainPage());
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    controller = new TabController(length: 4, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.purple));
    return Scaffold(
        floatingActionButton: Container(
          height: 74.0,
          width: 74.0,
          child: FittedBox(
            child: FloatingActionButton(
              backgroundColor: Colors.purple,
              child: const Icon(Icons.add),
              onPressed: () {
                qr_add.QRCodeReader().scan();
              },
            ),
          ),
        ),
        appBar: AppBar(
            title: TabBar(
          indicator: UnderlineTabIndicator(
              insets: EdgeInsets.symmetric(horizontal: 16.0),
              borderSide: BorderSide(color: Colors.black)),
          controller: controller,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white,
          tabs: <Widget>[
            Tab(icon: Icon(FontAwesomeIcons.home)),
            Tab(icon: Icon(FontAwesomeIcons.shareAlt)),
            Tab(icon: Icon(FontAwesomeIcons.bell)),
            Tab(icon: Icon(FontAwesomeIcons.user)),
          ],
        )),
        body: TabBarView(
          controller: controller,
          children: <Widget>[HomaPage()],
        ));
  }
}

class HomaPage extends StatefulWidget {
  @override
  _HomaPageState createState() => _HomaPageState();
}

class _HomaPageState extends State<HomaPage> {
  List devices = ["device1", "device2"];
  List status = ["on", "off"];
  List topic = ["topic1", "topic2"];

  bool _value = false;

  void _onChanged(bool value) {
    setState(() {
      _value = value;
      if (value == false) {
        print("ChangedToFalseeeee");
        mqtt.Publish("OFF");
      } else {
        print("ChangedToTrueeeeeee");
        mqtt.Publish("ON");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      body: Container(
//        color: Color(0xFFe6eeff),
        child: ListView.builder(
          itemCount: 2,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) => Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 9.0),
                child: Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 55.0,
                              height: 55.0,
                              color: Colors.transparent,
                              child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.green,
                                  backgroundImage: AssetImage(
                                      "assets/img/bethemeBehpardazan.png")),
                            ),
                            SizedBox(width: 5.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(devices[index],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                  status[index],
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12.0),
                                )
                              ],
                            )
                          ],
                        ),
//                        Container(
//                         alignment: Alignment.center,
//                          padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
//                          child: new Switch(value: _value, onChanged: (bool status){
//                            _onChanged(status);
//                          }),
//                        ),
                      ],
                    ),
                  ),
                ),
              ),
        ),
      ),
    );
  }

  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 3),
    ));
  }
}
