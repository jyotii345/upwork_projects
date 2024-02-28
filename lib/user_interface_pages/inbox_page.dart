import 'package:aggressor_adventures/classes/aggressor_colors.dart';
import 'package:aggressor_adventures/classes/globals.dart';
import 'package:aggressor_adventures/classes/globals_user_interface.dart';
import 'package:aggressor_adventures/classes/pinch_to_zoom.dart';
import 'package:aggressor_adventures/classes/user.dart';
import 'package:aggressor_adventures/user_interface_pages/message_view_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../bloc/message_bloc/message_bloc.dart';
import '../classes/messages.dart';
import 'package:timezone/standalone.dart' as tz;

class InboxPage extends StatefulWidget {
  InboxPage(
    this.user,
  );

  final User user;

  @override
  State<StatefulWidget> createState() => new InboxPageState();
}

class InboxPageState extends State<InboxPage>
    with AutomaticKeepAliveClientMixin {
  String errorMessage = "";

  bool loading = false;

  @override
  void initState() {
    super.initState();
    // var x=UserDatabaseHelper.instance;
    // x.database;
    print(widget.user);
    print(profileData);

    BlocProvider.of<MessageBloc>(context).add(GetAllMessageEvent(
        contactId: widget.user.contactId!, userId: widget.user.userId!));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RefreshIndicator(
        onRefresh: () {
          return Future.delayed(Duration(seconds: 1), () {
            BlocProvider.of<MessageBloc>(context).add(ReloadAllMessageEvent(
                contactId: widget.user.contactId!,
                userId: widget.user.userId!));
          });
        },
        edgeOffset: 100,
        child: OrientationBuilder(builder: (context, orientation) {
          portrait = orientation == Orientation.portrait;
          return PinchToZoom(
            Stack(
              children: [
                getBackgroundImage(),
                getWhiteOverlay(),
                getPageForm(),
                // TextButton(
                //   onPressed: () async {
                //     bool res = await AggressorApi().sendMessage("12");
                //   },
                //   child: Text("asd"),),
              ],
            ),
          );
        }));
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
            padding: const EdgeInsets.all(10.0),
            child: getMessagesSection(),
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
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          "Inbox",
          style: TextStyle(
              color: AggressorColors.primaryColor,
              fontSize: portrait
                  ? MediaQuery.of(context).size.height / 30
                  : MediaQuery.of(context).size.width / 30,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget getMessagesSection() {
    return BlocConsumer<MessageBloc, MessageState>(
      listener: (context, state) {
        if (state.msg != "") {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.msg),
            ),
          );
        }
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Container(
            color: Colors.white,
            child: (state.isLoading || state.isInitState)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : (state.messagesList!.length == 0)
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child:
                                Text("You do not have any notification yet."),
                          ),
                        ],
                      )
                    : getMessagesView(
                        state.messagesList!, state.timeZone ?? ""),
          ),
        );
      },
    );
  }

  Widget getMessagesView(List<Message> messageList, String timeZone) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: messageList.length,
        reverse: true,
        itemBuilder: (context, position) {
          DateTime timeNow = DateTime.now();
          if (timeZone != "") {
            tz.Location detroit = tz.getLocation(timeZone);
            timeNow = tz.TZDateTime.from(
              DateTime.now(),
              detroit,
            );
          }

          return Slidable(
            child: Container(
              width: double.infinity,
              color: AggressorColors.accentYellow,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: .5,
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 5,
                          backgroundColor: messageList[position].opened
                              ? Colors.transparent
                              : AggressorColors.primaryColor,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              BlocProvider.of<MessageBloc>(context).add(
                                ViewedMessagesEvent(
                                  contactId: widget.user.contactId!,
                                  messageId: messageList[position].id,
                                  messageIndex: position,
                                ),
                              );

                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MessageViewPage(widget.user, position),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    messageList[position].title,
                                    textAlign: TextAlign.left,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontWeight: messageList[position].opened
                                          ? FontWeight.normal
                                          : FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (messageList[position].flagged)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: 5.0,
                              ),
                              child: Icon(
                                Icons.flag,
                                size: 20,
                                color: AggressorColors.primaryColor,
                              ),
                            ),
                          ),
                        Column(
                          children: [
                            Text(
                              // (messageList[position].dateCreated.year <=
                              //     timeNow.year &&
                              //         messageList[position].dateCreated.month <=
                              //             timeNow.month &&
                              //         messageList[position].dateCreated.day <
                              //             timeNow.day)

                              (DateTime(timeNow.year, timeNow.month,
                                              timeNow.day)
                                          .compareTo(DateTime(
                                        messageList[position].dateCreated.year,
                                        messageList[position].dateCreated.month,
                                        messageList[position].dateCreated.day,
                                      )) ==
                                      1)
                                  ? "${messageList[position].dateCreated.month}/${messageList[position].dateCreated.day}"
                                  : "${messageList[position].dateCreated.toString().substring(11, 16)}",
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: messageList[position].opened
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            endActionPane: ActionPane(
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  backgroundColor: AggressorColors.primaryColor,
                  icon: messageList[position].flagged
                      ? Icons.flag
                      : Icons.flag_outlined,
                  onPressed: (BuildContext? context) {
                    messageList[position].flagged
                        ? BlocProvider.of<MessageBloc>(this.context).add(
                            UnFlaggedMessagesEvent(
                                contactId: widget.user.contactId!,
                                messageId: messageList[position].id,
                                messageIndex: position))
                        : BlocProvider.of<MessageBloc>(this.context).add(
                            FlaggedMessagesEvent(
                                contactId: widget.user.contactId!,
                                messageId: messageList[position].id,
                                messageIndex: position));
                  },
                ),
                SlidableAction(
                  backgroundColor: Colors.red,
                  icon: Icons.delete,
                  onPressed: (BuildContext? context) {
                    BlocProvider.of<MessageBloc>(this.context)
                        .add(DeleteMessagesEvent(
                      contactId: widget.user.contactId!,
                      messageId: messageList[position].id,
                      messageIndex: position,
                    ));
                  },
                ),
              ],
            ),
          );
        });
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
