import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:launcher_assist/launcher_assist.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class Insta extends StatefulWidget {
  @override
  _InstaState createState() => _InstaState();
}
List finalList =new List();
List videoList =new List();
List imgList =new List();
List thumbnailList=new List();
List downloadList= new List();
List imgDownloadBar= new List();
List vidDownloadBar= new List();
bool loading =false;
bool _isInterstitialAdLoaded = false;




class _InstaState extends State<Insta> with AutomaticKeepAliveClientMixin<Insta>{


  @override
  void initState()  {
    // TODO: implement initState
    requestPermission();
    resetData();


    //FB ads
    FacebookAudienceNetwork.init(
      testingId: "d1aca6d9-5680-4699-b673-b62b621ce86d",
    );
    super.initState();
  }

void resetData(){
  imgList.clear();
  videoList.clear();
  finalList.clear();
  thumbnailList.clear();
  downloadList.clear();
  imgDownloadBar.clear();
  vidDownloadBar.clear();
}
  requestPermission() async {
    if(await Permission.storage.status.isGranted){
     new Directory("storage/emulated/0/Media Saver").create(recursive: true);
     new Directory("storage/emulated/0/Media Saver/.thumbnails").create(recursive: true);
    }
    else{
      Permission.storage.request();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FloatingActionButton(
              heroTag: null,
              onPressed: () {
                LauncherAssist.launchApp('com.instagram.android');
              },
              materialTapTargetSize: MaterialTapTargetSize.padded,
              backgroundColor: Colors.pink,
              child: FaIcon(FontAwesomeIcons.instagram,size: 30,color: Colors.white,)
          ),
          SizedBox(
            height: 10.0,
          ),
          FloatingActionButton(
            heroTag: null,
            onPressed: (){
              setState(() {
                loading=true;
                resetData();
                getInstaLinks();
              });
            },
            materialTapTargetSize: MaterialTapTargetSize.padded,
            backgroundColor: Colors.pink,
            child: FaIcon(FontAwesomeIcons.retweet,size: 30,color: Colors.white,),
          ),
        ],
      ),
      body: FutureBuilder(
        future:getInstaLinks(),
        builder: (context,instaData){



    if(instaData.data!=null ){
      if(instaData.data[0].toString()=='error' ){
        return Center(
          child: Text(
              'Please copy the correct url and press refresh',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17.0,
                fontWeight:
                FontWeight.bold,
            ),
          ),
        );
      }
      if(loading){
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
            return CustomScrollView(slivers: <Widget>[
              ImageWidget(),
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
              VideoWidget(),


            ],
            );
          }
    if(loading){
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
        },
      )
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class ImageWidget extends StatefulWidget {
  const ImageWidget({
    Key key,
  }) : super(key: key);

  @override
  _ImageWidgetState createState() => _ImageWidgetState();
}
class _ImageWidgetState extends State<ImageWidget> {

  void initState() {
    // TODO: implement initState
    _loadInterstitialAd();
    super.initState();
  }

  void _loadInterstitialAd() {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: "554511951874232_554563641869063",
      listener: (result, value) {
        print("Interstitial Ad: $result --> $value");
        if (result == InterstitialAdResult.LOADED)
          _isInterstitialAdLoaded = true;

        /// Once an Interstitial Ad has been dismissed and becomes invalidated,
        /// load a fresh Ad by calling this function.
        if (result == InterstitialAdResult.DISMISSED &&
            value["invalidated"] == true) {
          _isInterstitialAdLoaded = false;
          _loadInterstitialAd();
        }
      },
    );
  }
  _showInterstitialAd() {
    if (_isInterstitialAdLoaded == true)
      FacebookInterstitialAd.showInterstitialAd();
    else
      print("Interstial Ad not yet loaded!");
  }

  requestPermission() async {
    if(await Permission.storage.status.isGranted){
    }
    else{
      Permission.storage.request();
    }
  }
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(bottom: 20.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
                (context, index)
          {
          return InkWell(
            onTap: ()=>print('Download ${imgList[index]}'),
            child: Container(
              child: Card(
                child: Column(
                  children: <Widget>[
                    Stack(
                      alignment:Alignment.center,
                        children: <Widget>[
                     Stack(alignment: Alignment.bottomCenter,children: <Widget>[
                       Image.network(imgList[index]),
                       Container(
                         color: Colors.black,
                         child: Center(
                           child:
                             RaisedButton(color: Colors.black,
                               onPressed:(){
                               _showInterstitialAd();
                               requestPermission();
                               Dio dio =new Dio();
                               var url=imgList[index].toString();
                               const start = '/v/';
                               const end = ".jpg";
                               final startIndex = url.indexOf(start);
                               final endIndex = url.indexOf(end, startIndex + start.length);
                               var fileName=(url.substring(startIndex + start.length+35, endIndex));
                               dio.download(imgList[index],
                                   '/storage/emulated/0/Media Saver/$fileName.jpg',
                               onReceiveProgress: (b,t){
                                 var progress=b/t*100;
                                 setState(() {
                                   imgDownloadBar[index]=double.parse(progress.toStringAsFixed(0))/100;
                                 });
                               });

                               print(imgList[index]);
                               },
                                 child: FaIcon(FontAwesomeIcons.download,size: 30,color: Colors.pink,),
                             )
                         ),
                       )
                     ],),
                          imgDownloadBar[index]==0?FaIcon(FontAwesomeIcons.image,size: 60,color: Colors.pink,):
                          imgDownloadBar[index]>0&&imgDownloadBar[index]<1?CircularPercentIndicator(
                            radius: 100,
                            lineWidth: 5.0,
                            percent: imgDownloadBar[index],
                            center: Text('${imgDownloadBar[index]*100}%'),
                            progressColor: Colors.pink,
                          ):
                          FaIcon(FontAwesomeIcons.checkCircle,size: 100,color: Colors.pink,)
                    ],
                    ),


                  ],

                ),
              ),
            ),
          );
        },
            childCount:imgList.length,
        )
      ),
    );
  }
}


class VideoWidget extends StatefulWidget {
  const VideoWidget({
    Key key,
  }) : super(key: key);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}
class _VideoWidgetState extends State<VideoWidget> {
  @override
  void initState() {
    // TODO: implement initState
    _loadInterstitialAd();
    super.initState();
  }

  void _loadInterstitialAd() {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: "554511951874232_554563641869063",
      listener: (result, value) {
        print("Interstitial Ad: $result --> $value");
        if (result == InterstitialAdResult.LOADED)
          _isInterstitialAdLoaded = true;

        /// Once an Interstitial Ad has been dismissed and becomes invalidated,
        /// load a fresh Ad by calling this function.
        if (result == InterstitialAdResult.DISMISSED &&
            value["invalidated"] == true) {
          _isInterstitialAdLoaded = false;
          _loadInterstitialAd();
        }
      },
    );
  }
  _showInterstitialAd() {
    if (_isInterstitialAdLoaded == true)
      FacebookInterstitialAd.showInterstitialAd();
    else
      print("Interstial Ad not yet loaded!");
  }
  requestPermission() async {
    if(await Permission.storage.status.isGranted){
    }
    else{
      Permission.storage.request();
    }
  }
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(bottom: 20.0),
      sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index)
            {
              return InkWell(
                onTap: ()=>print('Download ${videoList[index]}'),
                child: Container(
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Stack(
                          alignment:Alignment.center,
                          children: <Widget>[
                            Stack(alignment: Alignment.bottomCenter,children: <Widget>[
                              Image.file(File(thumbnailList[index]),),
                              Container(
                                color: Colors.black,
                                child: Center(
                                    child:
                                    RaisedButton(color: Colors.black,
                                      onPressed:(){
                                      _showInterstitialAd();
                                      requestPermission();
                                        Dio dio =new Dio();
                                        var url=videoList[index].toString();
                                        const start = '/v/';
                                        const end = ".mp4";
                                        final startIndex = url.indexOf(start);
                                        final endIndex = url.indexOf(end, startIndex + start.length);
                                        var fileName=(url.substring(startIndex + start.length+20, endIndex));
                                        dio.download(videoList[index],
                                            '/storage/emulated/0/Media Saver/$fileName.mp4',
                                            onReceiveProgress: (b,t){
                                              var progress=b/t*100;
                                              setState(() {
                                                vidDownloadBar[index]=double.parse(progress.toStringAsFixed(0))/100;
                                              });
                                            });

                                        print(videoList[index]);
                                      },
                                      child: FaIcon(FontAwesomeIcons.download,size: 30,color: Colors.pink,),
                                    )
                                ),
                              )
                            ],),
                            vidDownloadBar[index]==0?FaIcon(FontAwesomeIcons.video,size: 60,color: Colors.pink,):
                            vidDownloadBar[index]>0&&vidDownloadBar[index]<1?CircularPercentIndicator(
                              radius: 100,
                              lineWidth: 5.0,
                              percent: vidDownloadBar[index],
                              center: Text('${vidDownloadBar[index]*100}%'),
                              progressColor: Colors.pink,
                            ):
                            FaIcon(FontAwesomeIcons.checkCircle,size: 100,color: Colors.pink,),
                          ],
                        ),


                      ],
                    ),
                  ),
                ),
              );
            },
            childCount:videoList.length,
          )
      ),
    );
  }
}



//insta scraper
Future<List> getInstaLinks() async {
  loading=true;
  var client = http.Client();
  String url= await getClipBoardData().then((data){
    return data ;
  });
  http.Response response;
  try{
    response = await client.get(url);
  }
  catch (e){
    return ['error'];

  }
  var document = parse(response.body).outerHtml.toString();
  const start = '<script type="text/javascript">window._sharedData = ';
  const end = ";</script>";
  final startIndex = document.indexOf(start);
  final endIndex = document.indexOf(end, startIndex + start.length);
  if(startIndex<0){
    print('error');

    return ['error'];
  }
  var data = (document.substring(startIndex + start.length, endIndex));
  print(data);
  var jsondata = json.decode(data);
  var isSingle = jsondata['entry_data']['PostPage'][0]["graphql"]
  ["shortcode_media"]['edge_sidecar_to_children'];
  try{
    if (isSingle == null) {
      if (jsondata['entry_data']['PostPage'][0]["graphql"]["shortcode_media"]["is_video"]) {
        var d=jsondata['entry_data']['PostPage'][0]["graphql"]["shortcode_media"]['video_url'];
        if(videoList.contains(d)){
        }
        else{
          videoList.add(d);
        }

      } else {
        var d=jsondata['entry_data']['PostPage'][0]["graphql"]["shortcode_media"]['display_url'];
        if(imgList.contains(d)){
        }
        else{
          imgList.add(d);
        }
      }
    }
    else {
      var edges = (jsondata['entry_data']['PostPage'][0]["graphql"]["shortcode_media"]['edge_sidecar_to_children']['edges']);
      for (var node in edges) {
        if (!node['node']['is_video']) {
          var d=node['node']['display_resources'][0]['src'];
          if(imgList.contains(d)){
          }
          else{
            imgList.add(d);
          }
        } else {
          var f=(node['node']['video_url']);
          if(videoList.contains(f)){

          }
          else{
            videoList.add(f);
          }

        }
      }
    }
    if(finalList.contains(imgList)){} else{finalList.add(imgList);}
    if(finalList.contains(videoList)){} else{finalList.add(videoList);}
  }
  catch (e){
    print('error man ${e.toString()}');
    return ['error'];

  }

for(var i in imgList){
  if(downloadList.contains(i)){
  }else{
    downloadList.add(i);
    imgDownloadBar.add(0);
  }
}
for(var i in videoList){
  if(downloadList.contains(i)){
  }else{
    downloadList.add(i);
    vidDownloadBar.add(0);
  }
}

  print('videolist $videoList');
  print('imgList $imgList' );
  await VideoThumbnails();
  print('thumanialList $thumbnailList');
  print(downloadList);
  print(imgDownloadBar);
  return finalList ;

}
Future<List> VideoThumbnails() async{
  for(var i in videoList){
    final thumbnailFile = await VideoThumbnail.thumbnailFile(
      video: i,
      thumbnailPath: 'storage/emulated/0/Media Saver/.thumbnails',
      imageFormat: ImageFormat.PNG,
      quality: 5,);
    if(thumbnailList.contains(thumbnailFile)){
      
    }else {
      thumbnailList.add(thumbnailFile);
    }
  }
  loading=false;
  return thumbnailList;
}



Future<String>  getClipBoardData()async{
  ClipboardData cdata;
  cdata= await Clipboard.getData('text/plain');
  return cdata.text;
}

