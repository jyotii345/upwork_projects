import 'dart:typed_data';
import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/globals_user_interface.dart';
import 'package:aggressor_adventures/classes/pinch_to_zoom.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

// import 'package:vimeo_player_flutter/vimeo_player_flutter.dart';
import 'package:vimeo_video_player/vimeo_video_player.dart';

// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../classes/aggressor_colors.dart';
import '../classes/globals.dart';

class Reels extends StatefulWidget {
  Reels(
    this.user,
    this.hideBars,
  );

  final VoidCallback hideBars;
  final User user;

  @override
  State<StatefulWidget> createState() => new ReelsState();
}

class ReelsState extends State<Reels> {
  /*
  instance vars
   */

  String errorMessage = "";
  bool loading = false;
  Future? reelFuture = AggressorApi().getReelsList();

  YoutubePlayerController? _controller;

  int loadingIndex = -1;

  /*
  initState
   */
  @override
  void initState() {
    super.initState();

    refreshReels();

    // AggressorApi().getReelImage(
    //   "24",
    //   "",
    // );
  }

  /*
  Build
   */

  Future<void> refreshReels() async {
    await Future.delayed(Duration(seconds: 2));
    reelFuture = AggressorApi().getReelsList();
    setState(() {});
    return;
  }

  @override
  Widget build(BuildContext context) {
    // const player = YoutubePlayerIFrame();
    return WillPopScope(
      onWillPop: poppingPage,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: PinchToZoom(
          RefreshIndicator(
            onRefresh: () {
              // refreshReels();
              return refreshReels(); // Future.delayed(Duration(seconds: 1),(){});
            },
            edgeOffset: 100,
            child: OrientationBuilder(
              builder: (context, orientation) {
                portrait = orientation == Orientation.portrait;
                return Stack(
                  children: [
                    getBackgroundImage(),
                    getPageForm(),
                    getBannerImage(),
                    showVideo
                        ? Container(
                            height: double.infinity,
                            width: double.infinity,
                            color: Colors.black,
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : Container(),
                    showVideo
                        ? Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).padding.top),
                            child: YoutubePlayerIFrame(
                              controller: _controller!,
                              aspectRatio: 9 / 16,
                            ),
                          )
                        : Container(),
                    showVideo
                        ? Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: AppBar().preferredSize.height,
                              ),
                              child: GestureDetector(
                                child: Padding(
                                  padding: const EdgeInsets.all(25.0),
                                  child: Icon(
                                    Icons.close_rounded,
                                    color: AggressorColors.primaryColor,
                                    size: portrait
                                        ? MediaQuery.of(context).size.width / 15
                                        : MediaQuery.of(context).size.height /
                                            15,
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    showVideo = false;
                                    widget.hideBars();
                                    _controller = null;
                                  });
                                },
                              ),
                            ),
                          )
                        : Container(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /*
  Self implemented
   */

  Widget getPageForm() {
    //returns the main contents of the page
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Container(
        color: Colors.white,
        child: ListView(
          children: [
            Opacity(
              opacity: 0,
              child: getBannerImage(),
            ),
            showLoading(),
            getPageTitle(),
            getVideoGrid(),
            loadingIndex == -1
                ? Container()
                : Center(
                    child: Text(
                      "Reel is loading, please wait.",
                      style: TextStyle(color: AggressorColors.primaryColor),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget getVideoGrid() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: reelFuture == null
          ? Container(
              width: 20,
              height: 20,
              color: Colors.red,
            )
          : FutureBuilder(
              future: reelFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<dynamic> reels = snapshot.data as List;
                  if (reels.isEmpty) {
                    Center(
                      child: Text("No reels to show at this time."),
                    );
                  }
                  return GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: reels.length,
                    itemBuilder: (context, index) {
                      if (!snapshot.hasData)
                        return Center(
                          child: CircularProgressIndicator(),
                        );

                      Future imageFuture = AggressorApi().getReelImage(
                        reels[index]["id"].toString(),
                        reels[index]["image"].toString(),
                      );

                      return FutureBuilder(
                          future: imageFuture,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              print(snapshot.error.toString());
                            }

                            if (!snapshot.hasData)
                              return Stack(
                                children: [
                                  Container(
                                    height: double.infinity,
                                    color: Colors.black26,
                                  ),
                                  Center(
                                    child: Icon(
                                      snapshot.hasError
                                          ? Icons.error
                                          : Icons.video_library_sharp,
                                      color: snapshot.hasError
                                          ? Colors.red
                                          : Colors.white,
                                    ),
                                  ),
                                  snapshot.hasError
                                      ? Container()
                                      : Align(
                                          alignment: Alignment.bottomCenter,
                                          child: LinearProgressIndicator(
                                            backgroundColor:
                                                AggressorColors.secondaryColor,
                                          ),
                                        )
                                ],
                              );
                            Uint8List imageFile = snapshot.data as Uint8List;
                            return GestureDetector(
                              onTap: () async {
                                try {
                                  AggressorApi().increaseReelCounter(
                                      reels[index]["id"].toString());

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VideoPlayer(
                                        videoUrl:
                                            reels[index]["vimeo"].toString(),
                                        reelTitle:
                                            reels[index]["title"].toString(),
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  print(e.toString());
                                }

                                // startChewie(
                                //     index,
                                //     reels[index]["id"].toString(),
                                //     reels[index]["video"].toString(),
                                //     reels[index]["youtube"].toString());
                              },
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Image.memory(
                                      imageFile,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.play_arrow_rounded,
                                            color: Colors.white,
                                            size: portrait
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    20
                                                : MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    20,
                                          ),
                                          Text(
                                            reels[index]["views"] ?? "0",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  loadingIndex != index
                                      ? Container()
                                      : Positioned.fill(
                                          child: Align(
                                            alignment: Alignment.topCenter,
                                            child: SizedBox(
                                              height: 3,
                                              child: LinearProgressIndicator(
                                                color: AggressorColors
                                                    .secondaryColor,
                                                backgroundColor: AggressorColors
                                                    .primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            );
                          });
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: portrait
                          ? MediaQuery.of(context).size.width / 3
                          : MediaQuery.of(context).size.height / 2,
                      crossAxisCount: 4,
                      childAspectRatio: 1 / 1.6,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
    );
  }

  Widget getBackgroundImage() {
    //this method return the blue background globe image that is lightly shown under the application, this also return the slightly tinted overview for it.
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: ColorFiltered(
        colorFilter:
            ColorFilter.mode(Colors.white.withOpacity(0.25), BlendMode.dstATop),
        child: Image.asset(
          "assets/pagebackground.png",
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
      ),
    );
  }

  Widget getBannerImage() {
    //returns banner image
    return Image.asset(
      "assets/bannerimage.png",
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.scaleDown,
    );
  }

  Widget showErrorMessage() {
    //displays an error message if there is one
    return errorMessage == ""
        ? Container()
        : Padding(
            padding: EdgeInsets.fromLTRB(20.0, 5.0, 10.0, 10.0),
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          );
  }

  Widget getPageTitle() {
    // returns the title of the page
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                "Reels",
                style: TextStyle(
                    color: AggressorColors.primaryColor,
                    fontSize: portrait
                        ? MediaQuery.of(context).size.height / 30
                        : MediaQuery.of(context).size.width / 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showLoading() {
    // displays a loading bar if data is being downloaded
    return loading
        ? Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0, 0),
            child: LinearProgressIndicator(
              backgroundColor: AggressorColors.primaryColor,
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          )
        : Container();
  }

  Future<bool> poppingPage() {
    setState(() {
      popDistance = 0;
    });
    return new Future.value(true);
  }

  // void startChewie(
  //     int index, String videoId, String videoName, String youtube) async {
  //   // await AggressorApi().increaseReelCounter(videoId);
  //
  //   setState(
  //     () {
  //       showVideo = true;
  //
  //       widget.hideBars();
  //       _controller = YoutubePlayerController(
  //         initialVideoId: YoutubePlayerController.convertUrlToId(youtube)!,
  //         params: YoutubePlayerParams(
  //           playlist: [YoutubePlayerController.convertUrlToId(youtube)!],
  //           startAt: Duration(seconds: 1),
  //           autoPlay: true,
  //           loop: true,
  //           mute: false,
  //         ),
  //       );
  //
  //       _controller!.listen((event) {
  //         if (!event.hasPlayed) {
  //           _controller!.play();
  //         }
  //       });
  //     },
  //   );
  // }

  @override
  void dispose() {
    try {
      // _controller.dispose();
    } catch (e) {
      debugPrint("error disposing video controller");
    }

    super.dispose();
  }
}

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({Key? key, required this.videoUrl, required this.reelTitle})
      : super(key: key);

  final String videoUrl;
  final String reelTitle;

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late VideoPlayerController controller;
  late FlickManager flickManager;

  Future<void> initializeVideo() async {
    try {
      controller = VideoPlayerController.network(
        widget.videoUrl,
      );

      flickManager = FlickManager(
          videoPlayerController: controller,
          autoPlay: true,
          autoInitialize: true);
    } catch (e) {
      print("Video Load Error");
    }
  }

  bool get _isVimeoVideo {
    var regExp = RegExp(
      r"^((https?)://)?(www.)?vimeo\.com/(\d+).*$",
      caseSensitive: false,
      multiLine: false,
    );
    final match = regExp.firstMatch(widget.videoUrl);
    if (match != null && match.groupCount >= 1) return true;
    return false;
  }

  @override
  void initState() {
    initializeVideo();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reelTitle),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          color: Colors.transparent,

          child: _isVimeoVideo
              ? VimeoVideoPlayer(url: widget.videoUrl, autoPlay: true)
              : FlickVideoPlayer(flickManager: flickManager),

          // VimeoPlayer(
          //   videoId: "70591644",
          // ),
        ),
      ),
    );
  }
}
