import 'package:mediadownloader/Screens/Downloads.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

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

class MainWidget extends StatefulWidget {
  const MainWidget({
    Key key,
  }) : super(key: key);

  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 0,
    minLaunches: 0,
    remindDays: 0,
    remindLaunches: 0,
    googlePlayIdentifier: 'com.kalki.mediadownloader',
  );
  void waInstructionsDialog(){
    showDialog(context: context,
        barrierDismissible: false,
        builder: ( c){
          return AlertDialog(
            contentPadding: EdgeInsets.only(left: 25, right: 25),
            title: Center(child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FaIcon(FontAwesomeIcons.whatsapp,size: 20,color: Colors.pink,),
                Text("  Instructions"),
              ],
            )),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: Container(
              height: 500,
              width: 300,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                        'Name of requestor: }'
                    ),
                    Text(
                      'Description:' * 20,
                    ),
                    Text(
                      'Help_Description',
                    ),
                    Text(
                      'Type of help needed:Help_TypeNeeded',
                    )
                  ],
                ),
              ),
            ),
            actions: <Widget>[

              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.20,
                  child: RaisedButton(
                    child: new Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.pink,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),

            ],
          );
        });
  }

  void instaInstructionsDialog(){
    showDialog(context: context,
        barrierDismissible: false,
        builder: ( c){
            return AlertDialog(
              contentPadding: EdgeInsets.only(left: 25, right: 25),
              title: Center(child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FaIcon(FontAwesomeIcons.instagram,size: 20,color: Colors.pink,),
                  Text("  Instructions"),
                ],
              )),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: Container(
                height: 500,
                width: 300,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                          'Name of requestor: }'
                      ),
                      Text(
                        'Description:' * 20,
                      ),
                      Text(
                        'Help_Description',
                      ),
                      Text(
                        'Type of help needed:Help_TypeNeeded',
                      )
                    ],
                  ),
                ),
              ),
              actions: <Widget>[

                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.20,
                    child: RaisedButton(
                      child: new Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.pink,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),

              ],
            );
         });
  }
  @override
  void initState() {
    super.initState();
    rateMyApp.init().then((_) {
      if (rateMyApp.shouldOpenDialog) {
        rateMyApp.showStarRateDialog(
          context,
          title: 'Rate this app', // The dialog title.
          message: 'Hope you like our App!'
              'Please, take a little bit of your time to leave a rating :',
          actionsBuilder: (_, stars) { // Triggered when the user updates the star rating.
            return [ // Return a list of actions (that will be shown at the bottom of the dialog).
              FlatButton(
                child: Text('OK'),
                onPressed: () async {
                  print('Thanks for the ' + (stars == null ? '0' : stars.round().toString()) + ' star(s) !');
                  if(stars!=null){


                  if(stars<3){
                    //mail
                    String url='mailto:kalkiarts2@gmail.com?subject=Suggestion- Image and Video downloader for Insta and  WhatsApp&body=Hi,';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  }else{
                    //rate us
                    String url='https://play.google.com/store/apps/details?id=com.kalki.mediadownloader';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  }
                  }
                  else{
                    print('null bro');
                  }
                  await rateMyApp.callEvent(RateMyAppEventType.rateButtonPressed);
                  Navigator.pop<RateMyAppDialogButton>(context, RateMyAppDialogButton.rate);
                },
              ),
            ];
          },
          ignoreIOS: false, // Set to false if you want to show the native Apple app rating dialog on iOS.
          dialogStyle: DialogStyle( // Custom dialog styles.
            titleAlign: TextAlign.center,
            messageAlign: TextAlign.center,
            messagePadding: EdgeInsets.only(bottom: 20),
          ),
          starRatingOptions: StarRatingOptions(), // Custom star bar rating options.
          onDismissed: () {
            rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed);
            print('dismissed');
          }
        );
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(drawer: Drawer(
      child:ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('Media Saver',
            style: TextStyle(fontSize: 30,
            ),
            ),
            currentAccountPicture: Image.asset('assets/images/HeaderImg.png'), accountEmail: null,
          ),
          ListTile(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return Downloads();
              }));
            },
            leading:FaIcon(FontAwesomeIcons.download,size: 20,color: Colors.pink,),
            title: Text('DOWNLOADS', style: TextStyle(fontWeight: FontWeight.bold),),
          ),
          ListTile(
            onTap: (){
              instaInstructionsDialog();
            },
            leading: FaIcon(FontAwesomeIcons.infoCircle,size: 20,color: Colors.pink,),
              title: Row(
                children: <Widget>[
                  Text('HOW TO USE '),FaIcon(FontAwesomeIcons.instagram,size: 20,color: Colors.pink,),Text(' SAVER')
                ],
              ),
            ),
          ListTile(
            onTap: (){
              waInstructionsDialog();
            },
            leading: FaIcon(FontAwesomeIcons.infoCircle,size: 20,color: Colors.pink,),
            title: Row(
              children: <Widget>[
                Text('HOW TO USE '),FaIcon(FontAwesomeIcons.whatsapp,size: 20,color: Colors.pink,),Text(' SAVER')
              ],
            ),
          ),
          Divider(),
          ListTile(onTap: ()async{
            String url='https://play.google.com/store/apps/developer?id=Kalki+Arts';
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          },
            leading:FaIcon(FontAwesomeIcons.googlePlay,size: 20,color: Colors.pink,),
            title: Text('OUR APPS'),
          ),
          ListTile(
            onTap: ()async{
              String url='https://play.google.com/store/apps/details?id=com.kalki.mediadownloader';
              if (await canLaunch(url)) {
              await launch(url);
              } else {
              throw 'Could not launch $url';
              }
            },
            leading:FaIcon(FontAwesomeIcons.solidStar,size: 20,color: Colors.pink,),
            title: Text('RATE US'),
          ),
          ListTile(
            leading:FaIcon(FontAwesomeIcons.share,size: 20,color: Colors.pink,),
            title: Text('SHARE'),
            onTap: (){
              Share.share('I found a great app. It can download all photos and videos from Instagram  and WhatsApp fast and free. Easy for you to enjoy offline or repost them, Please have a try now: https://play.google.com/store/apps/details?id=com.kalki.mediadownloader',);
            },
          ),
          ListTile(
            onTap: ()async{
              String url='mailto:kalkiarts2@gmail.com?subject=Suggestion- Image and Video downloader for Insta and  WhatsApp&body=Hi,';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
            leading:FaIcon(FontAwesomeIcons.paperPlane,size: 20,color: Colors.pink,),
            title: Text('MAIL US'),
          )

        ],
      ) ,
    ),

          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100),
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

