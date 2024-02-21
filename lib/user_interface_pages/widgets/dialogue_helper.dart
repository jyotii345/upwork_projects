import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/message_bloc/message_bloc.dart';



class CustomDialogues{
 static Future<void> notificationDialog(String msg, String title,context,Function onClose,String contactId, String userId,
      {String? imageUrl}){
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          alignment: Alignment.center,
          title: Column(
            children: [
              imageUrl == null
                  ? Image.asset(
                "assets/notification.png",
                scale: 3,
              )
                  : Image.network(
                imageUrl,
                scale: 3,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          content: Text(
            msg,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Center(
              child: TextButton(
                child: const Text('Close'),
                onPressed: () {
                  BlocProvider.of<MessageBloc>(context)
                      .add(ReloadAllMessageEvent(contactId: contactId,userId: userId));
                  Navigator.of(context).pop();
                  onClose();
                },
              ),
            ),
          ],
        );
      },
    );
  }


 // static Future<void> vimeoErrorDialog(context
 //     ){
 //   return showDialog<void>(
 //     context: context,
 //     barrierDismissible: false, // user must tap button!
 //     builder: (BuildContext context) {
 //       return AlertDialog(
 //         alignment: Alignment.center,
 //         title: Column(
 //           children: [
 //
 //             Padding(
 //               padding: const EdgeInsets.only(top: 25.0),
 //               child: Text(
 //                 "Vimeo Video Error",
 //                 textAlign: TextAlign.center,
 //               ),
 //             ),
 //           ],
 //         ),
 //         content: Text(
 //           "Vimeo Video not found",
 //           textAlign: TextAlign.center,
 //         ),
 //         actions: <Widget>[
 //           Center(
 //             child: TextButton(
 //               child: const Text('Close'),
 //               onPressed: () {
 //                 Navigator.of(context).pop();
 //               },
 //             ),
 //           ),
 //         ],
 //       );
 //     },
 //   );
 // }
}