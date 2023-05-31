import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/globals_user_interface.dart';
import 'package:aggressor_adventures/classes/pinch_to_zoom.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/message_bloc/message_bloc.dart';
import '../classes/messages.dart';

class MessageViewPage extends StatefulWidget {
  MessageViewPage(this.user, this.messageIndex);

  final User user;
  final int messageIndex;

  @override
  State<StatefulWidget> createState() => new MessageViewPageState();
}

class MessageViewPageState extends State<MessageViewPage>
    with AutomaticKeepAliveClientMixin {
  String errorMessage = "";

  bool loading = false;

  List<Message> notifications = [];

  @override
  void initState() {
    super.initState();
    popDistance = 1;
    outterDistanceFromLogin = 1;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    popDistance = 0;
    outterDistanceFromLogin = 0;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: getAppBar(),
      bottomNavigationBar: getCouponBottomNavigationBar(),
      body: OrientationBuilder(builder: (context, orientation) {
        portrait = orientation == Orientation.portrait;
        return PinchToZoom(
          Stack(
            children: [
              getBackgroundImage(),
              getWhiteOverlay(),
              getPageForm(),
            ],
          ),
        );
      }),
    );
  }

  /*
  Self implemented
   */

  Widget getWhiteOverlay() {
    // returns a white background on the application
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Container(
        color: Colors.white,
      ),
    );
  }

  Widget getPageForm() {
    // returns the main contents of the page
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: ListView(
        children: [
          getBannerImage(),
          showOffline(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: getPageTitle(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Divider(
              color: Colors.black12,
              thickness: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: getMessageSection(),
          ),
          showErrorMessage(),
        ],
      ),
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

  Widget getPageTitle() {
    //returns the title of the page
    return BlocBuilder<MessageBloc, MessageState>(
      builder: (context, state) {
        return state.messagesList!.length > widget.messageIndex
            ? Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "${state.messagesList![widget.messageIndex].dateCreated.toString().substring(11,16)}, ",
                            // "${state.messagesList![widget.messageIndex].dateCreated.hour}:${state.messagesList![widget.messageIndex].dateCreated.minute}, ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: portrait
                                  ? MediaQuery.of(context).size.height / 70
                                  : MediaQuery.of(context).size.width / 70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "${state.messagesList![widget.messageIndex].dateCreated.month}-${state.messagesList![widget.messageIndex].dateCreated.day}-${state.messagesList![widget.messageIndex].dateCreated.year}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: portrait
                                  ? MediaQuery.of(context).size.height / 70
                                  : MediaQuery.of(context).size.width / 70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              state.messagesList![widget.messageIndex].flagged
                                  ? BlocProvider.of<MessageBloc>(context)
                                      .add(UnFlaggedMessagesEvent(
                                      contactId: widget.user.contactId!,
                                      messageId: state
                                          .messagesList![widget.messageIndex]
                                          .id,
                                      messageIndex: widget.messageIndex,
                                    ))
                                  : BlocProvider.of<MessageBloc>(context)
                                      .add(FlaggedMessagesEvent(
                                      contactId: widget.user.contactId!,
                                      messageId: state
                                          .messagesList![widget.messageIndex]
                                          .id,
                                      messageIndex: widget.messageIndex,
                                    ));
                            },
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5),
                                child: Icon(
                                  state.messagesList![widget.messageIndex]
                                          .flagged
                                      ? Icons.flag
                                      : Icons.flag_outlined,
                                  size: 25,
                                  color: AggressorColors.primaryColor,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              BlocProvider.of<MessageBloc>(context)
                                  .add(DeleteMessagesEvent(
                                contactId: widget.user.contactId!,
                                messageId:
                                    state.messagesList![widget.messageIndex].id,
                                messageIndex: widget.messageIndex,
                              ));
                            },
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 5),
                                child: Icon(
                                  Icons.delete,
                                  size: 25,
                                  color: AggressorColors.primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Text(
                        state.messagesList![widget.messageIndex].title,
                        style: TextStyle(
                            color: AggressorColors.primaryColor,
                            fontSize: portrait
                                ? MediaQuery.of(context).size.height / 35
                                : MediaQuery.of(context).size.width / 35,
                            fontWeight: FontWeight.bold),
                      ),
                      // Text(
                      //   state.messagesList![widget.messageIndex].subTitle,
                      //   style: TextStyle(
                      //       color: AggressorColors.primaryColor,
                      //       fontSize: portrait
                      //           ? MediaQuery.of(context).size.height / 50
                      //           : MediaQuery.of(context).size.width / 50,
                      //       fontWeight: FontWeight.w600),
                      // ),
                    ],
                  ),
                ),
              )
            : Container();
      },
    );
  }

  Widget getMessageSection() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Container(
        color: Colors.white,
        child: getMessageView(),
      ),
    );
  }

  Widget getMessageView() {
    return Container(
      width: double.infinity,
      // color: AggressorColors.accentYellow,
      child: BlocConsumer<MessageBloc, MessageState>(
        listener: (context, state) {
          if (state.isDeleted) {
            Navigator.pop(context);
            popDistance = 0;
          }
          // if (state.msg != "") {
          //   ScaffoldMessenger.of(context).hideCurrentSnackBar();
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(
          //       content: Text(state.msg),
          //     ),
          //   );
          // }
        },
        builder: (context, state) {
          return state.messagesList!.length > widget.messageIndex
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   state.messagesList![widget.messageIndex].body,
                    //   style: TextStyle(
                    //       color: Colors.black,
                    //       fontSize: portrait
                    //           ? MediaQuery.of(context).size.height / 50
                    //           : MediaQuery.of(context).size.width / 50,
                    //       fontWeight: FontWeight.w600),
                    // ),
                    Text(
                      state.messagesList![widget.messageIndex].messageBody,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: portrait
                              ? MediaQuery.of(context).size.height / 60
                              : MediaQuery.of(context).size.width / 60,
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                )
              : Container();
        },
      ),
    );
  }

  Widget showErrorMessage() {
    // shows an error message if there is one
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

  Widget showLoading() {
    // shows a loading line if the notes are being downloaded
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

  Widget showOffline() {
    // displays offline when the application does not have internet connection
    return online
        ? Container()
        : Container(
            color: Colors.red,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
              child: Text(
                "Application is offline",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          );
  }

  @override
  bool get wantKeepAlive => true;

/*
  self implemented
   */

}
