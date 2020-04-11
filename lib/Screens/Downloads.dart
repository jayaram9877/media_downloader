import 'dart:io';

import 'package:facebook_audience_network/ad/ad_native.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mediadownloader/Screens/Insta.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_it/share_it.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class Downloads extends StatefulWidget {
  @override
  _DownloadsState createState() => _DownloadsState();

}
List vidList= new List();

class _DownloadsState extends State<Downloads> with AutomaticKeepAliveClientMixin<Downloads> {

  @override
  void initState() {
    requestPermission();
    super.initState();
    FacebookAudienceNetwork.init(
      testingId: "d1aca6d9-5680-4699-b673-b62b621ce86d",
    );
  }

  List imgList= new List();
  List thumbnailsList= new List();
  var dir = new Directory('/storage/emulated/0/Media Saver/');

  requestPermission() async {
    if(await Permission.storage.status.isGranted){
    }
    else{
      Permission.storage.request();
    }
  }

  Future<List> listFiles() async {
    List contents = dir.listSync();
    for (var fileOrDir in contents) {
      var f=(fileOrDir.toString().substring(fileOrDir
          .toString()
          .length - 4, fileOrDir
          .toString()
          .length - 1));
      if ( f=='jpg') {
        if(imgList.contains(fileOrDir.toString())){

        }else{
          imgList.add(fileOrDir);
        }
      }
      if (f=='mp4') {
        if(videoList.contains(fileOrDir)){

        }else{
          vidList.add(fileOrDir);
        }
        final thumbnailFile = await VideoThumbnail.thumbnailFile(
          video: fileOrDir.path,
          imageFormat: ImageFormat.PNG,
          maxWidth: 190, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
          quality: 25,
        );
        if(thumbnailsList.contains(thumbnailFile)){

        }else{
          thumbnailsList.add(thumbnailFile);

        }
      }
    }
    print(contents);
    print('downlloads$imgList');
    print('downloads$vidList');
    return ['got it'];
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: FaIcon(FontAwesomeIcons.chevronLeft,size: 20,color: Colors.pink,),
          onPressed: ()=>Navigator.pop(context)),
          title: Text('Downloads'),
        ),
  body: FutureBuilder(
    future: listFiles(),
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
      ImgWidget(imgList: imgList,),
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
      vidWidget(thumbnailsList: thumbnailsList,)
    ]
    );
    }
    return Center(child: SizedBox(
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
    )
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}


class ImgWidget extends StatefulWidget {

  const ImgWidget({
    Key key,
    @required this.imgList,
  }) : super(key: key);

  final List imgList;

  @override
  _ImgWidgetState createState() => _ImgWidgetState();
}

class _ImgWidgetState extends State<ImgWidget> {


  @override
  Widget build(BuildContext context, ) {
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
              child: Card(
                  elevation: 100,
                  color: Colors.grey[800],
                  child: Stack(
                    alignment:Alignment.bottomRight,
                    children: <Widget>[
                      InkWell(
                        onTap: (){
                          OpenFile.open(widget.imgList[index].path);
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Image.file(File(widget.imgList[index].path),height: 190,width: 190,),
                            FaIcon(FontAwesomeIcons.image,size: 30,color: Colors.pink,)
                          ],
                        ),
                      ),
                      InkWell(
                          onTap: () async{
                            ShareIt.file(
                                path: await widget.imgList[index].path,
                                type: ShareItFileType.image
                            );
                          },

                          child: FaIcon(FontAwesomeIcons.share,size: 30,color: Colors.pink,))
                    ],
                  )
              ),
            );

          },
          childCount: widget.imgList.length

      ),
    );
  }
}

class vidWidget extends StatefulWidget  {

  const vidWidget({
    Key key,
    @required this.thumbnailsList,
  }) : super(key: key);

  final List thumbnailsList;


  @override
  _vidWidgetState createState() => _vidWidgetState();
}

class _vidWidgetState extends State<vidWidget> {


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
              child: Card(
                elevation: 100,
                color: Colors.grey[800],
                child: Stack(
                  alignment:Alignment.bottomRight,
                  children: <Widget>[
                    InkWell(
                      onTap: (){
                        OpenFile.open(vidList[index].path);
                      },
                 child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Image.file(File(widget.thumbnailsList[index]),height: 190,width: 190,),
                      FaIcon(FontAwesomeIcons.play,size: 30,color: Colors.pink,)
                    ],
                  ),
                    ),
                  InkWell(
                    onTap: () async{
                      ShareIt.file(
                          path: await vidList[index].path,
                          type: ShareItFileType.video
                      );
                    },
                      child: FaIcon(FontAwesomeIcons.share,size: 30,color: Colors.pink,)
                  )
                ],
                )
              ),
            );

          },
          childCount: widget.thumbnailsList.length

      ),
    );
  }
}