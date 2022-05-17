import 'dart:io';

import 'package:aggressor_adventures/classes/aggressor_api.dart';
import 'package:aggressor_adventures/classes/globals_user_interface.dart';
import 'package:aggressor_adventures/classes/pinch_to_zoom.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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

  Future reelFuture = AggressorApi().getReelsList();

  YoutubePlayerController _controller;

  int loadingIndex = -1;

  /*
  initState
   */
  @override
  void initState() {
    super.initState();
  }

  /*
  Build
   */

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: poppingPage,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: PinchToZoom(
          OrientationBuilder(
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
                        )
                      : Container(),
                  showVideo
                      ? Center(
                          child: YoutubePlayerBuilder(
                              player: YoutubePlayer(
                                liveUIColor: Colors.pink,
                                actionsPadding: EdgeInsets.all(5),
                                controller: _controller,
                                showVideoProgressIndicator: true,
                                progressColors: ProgressBarColors(
                                  playedColor: AggressorColors.primaryColor,
                                  handleColor: AggressorColors.secondaryColor,
                                ),
                                onEnded: (metaData) {
                                  setState(() {
                                    showVideo = false;
                                    widget.hideBars();
                                    _controller = null;
                                  });
                                },
                              ),
                              builder: (context, player) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            top: AppBar().preferredSize.height,
                                            bottom:
                                                AppBar().preferredSize.height,
                                          ),
                                          child: player,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
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
                                      : MediaQuery.of(context).size.height / 15,
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
      child: FutureBuilder(
          future: reelFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<dynamic> reels = snapshot.data;
              if (reels.isEmpty) {
                return Center(
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
                      child: CircularProgressIndicator(
                        color: AggressorColors.secondaryColor,
                      ),
                    );

                  Future imageFuture = AggressorApi().getReelImage(
                      reels[index]["id"].toString(),
                      reels[index]["image"].toString());

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
                        File imageFile = snapshot.data;
                        return GestureDetector(
                          onTap: () async {
                            startChewie(
                                index,
                                reels[index]["id"].toString(),
                                reels[index]["video"].toString(),
                                reels[index]["youtube"].toString());
                          },
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Image.file(
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
                                        reels[index]["views"].toString() ?? "0",
                                        style: TextStyle(color: Colors.white),
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
                                            color:
                                                AggressorColors.secondaryColor,
                                            backgroundColor:
                                                AggressorColors.primaryColor,
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
              child: CircularProgressIndicator(
                color: AggressorColors.primaryColor,
              ),
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
    //returns the title of the page
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
    //displays a loading bar if data is being downloaded
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

  void startChewie(
      int index, String videoId, String videoName, String youtube) async {
//shows the image in a larger view

    await AggressorApi().increaseReelCounter(videoId);

    setState(() {
      showVideo = true;

      widget.hideBars();

      _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(youtube),
        flags: YoutubePlayerFlags(
          autoPlay: true,
          loop: true,
          mute: false,
        ),
      );
    });
  }

  @override
  void dispose() {
    try {
      _controller.dispose();
    } catch (e) {
      debugPrint("error disposing video controller");
    }

    super.dispose();
  }
}
