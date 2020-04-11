import 'dart:io';
import 'package:facebook_audience_network/ad/ad_native.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:launcher_assist/launcher_assist.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path/path.dart' as path;
import 'Insta.dart';



class WhatsApp extends StatefulWidget {
  @override
  _WhatsAppState createState() => _WhatsAppState();
}

class _WhatsAppState extends State<WhatsApp> with AutomaticKeepAliveClientMixin<WhatsApp>{
 static String WASTATUS_DIR='/storage/emulated/0/WhatsApp/Media/.Statuses/';
  @override
  void initState() {
    // TODO: implement initState
    requestPermission();
    listFiles();
    //FB ads
    FacebookAudienceNetwork.init(
      testingId: "d1aca6d9-5680-4699-b673-b62b621ce86d",
    );
    super.initState();
  }
  requestPermission() async {
    if(await Permission.storage.status.isGranted){

    }
    else{
      Permission.storage.request();
    }
  }
  var dir = new Directory(WASTATUS_DIR);
  List imgList = new List<File>();
  List videoList = new List<File>();
  List videoThumbnail = new List<File>();


  void listFiles() async {
    List contents = dir.listSync();
    for (var fileOrDir in contents) {
      if ((fileOrDir.toString().substring(fileOrDir
          .toString()
          .length - 4, fileOrDir
          .toString()
          .length - 1)) == 'jpg') {
        imgList.add(fileOrDir);
      }
    }
  }
  Future<List> VlistFiles() async {

    List contents =  dir.listSync();
    for (File fileOrDir in contents) {
      if ((fileOrDir.toString().substring(fileOrDir.toString().length-4,fileOrDir.toString().length-1))=='mp4') {
        videoList.add(fileOrDir);

        final thumbnailFile = await VideoThumbnail.thumbnailFile(
          video: fileOrDir.path,
          imageFormat: ImageFormat.PNG,
          maxWidth: 190, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
          quality: 25,
        );
        if(videoThumbnail.contains(File(thumbnailFile))){

        }else{
          videoThumbnail.add(File(thumbnailFile));

        }
      }
    }
    return thumbnailList;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
child: FaIcon(FontAwesomeIcons.whatsapp,size: 30,color: Colors.white,),
        onPressed: () async{
          LauncherAssist.launchApp('com.whatsapp');
}

      ),
      body: FutureBuilder(
        future: VlistFiles(),
builder: (context, Vdata){
           if(Vdata.data!=null){
             return CustomScrollView(
               slivers: <Widget>[
                 SliverSafeArea(
                     sliver:SliverToBoxAdapter(
                       child: FacebookNativeAd(
                         placementId: "554511951874232_554573681868059",
                         adType: NativeAdType.NATIVE_BANNER_AD,
                         width: double.infinity,
                         height: 300,
                         backgroundColor: Colors.blue,
                         titleColor: Colors.white,
                         descriptionColor: Colors.white,
                         buttonColor: Colors.deepPurple,
                         buttonTitleColor: Colors.white,
                         buttonBorderColor: Colors.white,
                         listener: (result, value) {
                           print("Native Ad: $result --> $value");
                         },
                       ),
                     )
                 ),
                 WAImageWidget(imgList: imgList),
                 SliverSafeArea(
                     sliver:SliverToBoxAdapter(
                       child: FacebookNativeAd(
                         placementId: "554511951874232_554517895206971",
                         adType: NativeAdType.NATIVE_AD,
                         width: double.infinity,
                         height: 300,
                         backgroundColor: Colors.blue,
                         titleColor: Colors.white,
                         descriptionColor: Colors.white,
                         buttonColor: Colors.deepPurple,
                         buttonTitleColor: Colors.white,
                         buttonBorderColor: Colors.white,
                         listener: (result, value) {
                           print("Native Ad: $result --> $value");
                         },
                       ),
                     )
                 ),
                 WAVideoWidget(videoThumbnail: videoThumbnail, videoList: videoList)
               ],
             );
           }
           return  Center(child: SizedBox(
             width: 200.0,
             height: 100.0,
             child: Shimmer.fromColors(
               baseColor: Colors.white10,
               highlightColor: Colors.white,
               child: Text(
                 'Loading',
                 textAlign: TextAlign.center,
                 style: TextStyle(
                   fontSize: 40.0,
                   fontWeight:
                   FontWeight.bold,
                 ),
               ),
             ),
           )
           );
        }

      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}

class WAVideoWidget extends StatelessWidget {
  const WAVideoWidget({
    Key key,
    @required this.videoThumbnail,
    @required this.videoList,
  }) : super(key: key);

  final List videoThumbnail;
  final List videoList;
  requestPermission() async {
    if(await Permission.storage.status.isGranted){
    }
    else{
      Permission.storage.request();
    }
  }
  @override
  Widget build(BuildContext context) {
    return SliverGrid(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 250.0,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 1.0,
        ),
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(videoThumbnail[index])
                    )

                ),
                child: InkWell(
                  onTap:() async{
                    requestPermission();
                    try{
                      String filename =path.basename(videoList[index].toString()).replaceAll("'", "");
                      await videoList[index].copy('/storage/emulated/0/Media Saver/$filename');
                      Fluttertoast.showToast(
                          msg: "Saved to /storage/emulated/0/Media Saver/$filename",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }
                    catch(e){
                      print(e);
                    }
                  },
                  child: Card(
                    color: Colors.transparent,
                    child: Center(
                      child: FaIcon(FontAwesomeIcons.play,size: 30,color: Colors.pink,),
                    ),
                  ),
                ),
              );

        },
        childCount: videoList.length

      ),
    );
  }
}

class WAImageWidget extends StatelessWidget {
  requestPermission() async {
    if(await Permission.storage.status.isGranted){
    }
    else{
      Permission.storage.request();
    }
  }
  const WAImageWidget({
    Key key,
    @required this.imgList,
  }) : super(key: key);

  final List imgList;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 250.0,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        childAspectRatio: 1.0,
      ),
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100)
                ),
                child: InkWell(
                  onTap:() async{
                    requestPermission();
                    try{
                      String filename =(path.basename(imgList[index].toString())).replaceAll("'", "");
                      print(filename);
                      await imgList[index].copy("/storage/emulated/0/Media Saver/$filename");

                      Fluttertoast.showToast(
                          msg: "Saved to /storage/emulated/0/Media Saver/$filename",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }
                    catch(e){
                      print(e);
                    }
                  },
                  child: Card(
                    elevation: 100,
                    color: Colors.grey[800],
                    child: Stack(alignment: Alignment.center, children: <Widget>[Image.file(imgList[index],height: 190,width: 190,),
                      FaIcon(FontAwesomeIcons.image,size: 30,color: Colors.pink,)],
                    ),
                  ),
                ),
              );

        },
        childCount: imgList.length

      ),
    );
  }
}
