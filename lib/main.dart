import 'Screens/WhatsApp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'Screens/Insta.dart';

void main() {
  runApp(HomeScreen());
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {

@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: DefaultTabController(
        length: 2,
    child: MainWidget()
      ),
    );
  }
}

class MainWidget extends StatelessWidget {
  const MainWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

          appBar: PreferredSize(
            preferredSize: Size.fromHeight(75),
            child: AppBar(
              iconTheme: IconThemeData(
                color: Colors.pink
              ),
              bottom: TabBar(
                tabs: [
                  Tab(icon:FaIcon(FontAwesomeIcons.instagram,size: 20, color: Colors.pink,)),
                  Tab(icon: FaIcon(FontAwesomeIcons.whatsapp,size: 20,color: Colors.pink,)),

                ],
              ),
            ),
          ),
          body: TabBarView(
            children: [
              Insta(),
              WhatsApp(),
            ],
          ),
        );
  }
}

