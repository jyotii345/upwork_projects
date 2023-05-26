import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:timezone/standalone.dart' as tz;

import '../../classes/aggressor_api.dart';
import '../../classes/messages.dart';

part 'message_event.dart';

part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  // AggressorApi aggressorApi;

  MessageBloc() : super(MessageState()) {
    on<GetAllMessageEvent>((event, emit) async {
      emit(state.copyWith(
        isInitState: false,
        isLoading: true,
        isSuccess: false,
      ));

      List<Message> messages =
          await AggressorApi().getAllMessages(event.contactId);

      var userProfileData = await AggressorApi().getProfileData(event.userId);
      String? timeZoneString =
          userProfileData != null ? userProfileData["time_zone"] : null;

      List<Message> messages2 = [];

      messages.forEach((element) {
        element.dateCreated =
            _getDateTime(element.timeCreated, element.dateCreated);

        if (timeZoneString != null) {

          final laTime = tz.TZDateTime(
            tz.getLocation("America/New_York"),
            element.dateCreated.year,
            element.dateCreated.month,
            element.dateCreated.day,
            element.dateCreated.hour,
            element.dateCreated.minute,
          );




          element.dateCreated=tz.TZDateTime.fromMicrosecondsSinceEpoch(tz.getLocation(timeZoneString), laTime.microsecondsSinceEpoch);
          messages2.add(element);
        } else {
          messages2.add(element);
        }
      });

      messages2.sort((a, b) => a.dateCreated.compareTo(b.dateCreated));

      emit(state.copyWith(
        isInitState: false,
        isLoading: false,
        isSuccess: true,
        messagesList: messages2,
        timeZone: timeZoneString,
      ));
    });

    on<ReloadAllMessageEvent>((event, emit) async {
      List<Message> messages =
          await AggressorApi().getAllMessages(event.contactId);

      var userProfileData = await AggressorApi().getProfileData(event.userId);
      String? timeZoneString =
          userProfileData != null ? userProfileData["time_zone"] : null;

      List<Message> messages2 = [];
      messages.forEach((element) {
        element.dateCreated =
            _getDateTime(element.timeCreated, element.dateCreated);

        if (timeZoneString != null) {
          // DateTime inUtc = DateTime.utc(
          //   element.dateCreated.year,
          //   element.dateCreated.month,
          //   element.dateCreated.day,
          //   element.dateCreated.hour,
          //   element.dateCreated.minute,
          //   element.dateCreated.second,
          // );
          // inUtc=inUtc.subtract(Duration(hours: 5));

          // var detroit = tz.getLocation(timeZoneString);
          // element.dateCreated =
          //     tz.TZDateTime.from(element.dateCreated, detroit);
          final laTime = tz.TZDateTime(
            tz.getLocation("America/New_York"),
            element.dateCreated.year,
            element.dateCreated.month,
            element.dateCreated.day,
            element.dateCreated.hour,
            element.dateCreated.minute,
          );
          element.dateCreated=tz.TZDateTime.fromMicrosecondsSinceEpoch(tz.getLocation(timeZoneString), laTime.microsecondsSinceEpoch);
          messages2.add(element);
        } else {
          messages2.add(element);
        }
      });

      messages2.sort((a, b) => a.dateCreated.compareTo(b.dateCreated));

      emit(state.copyWith(
        isInitState: false,
        isLoading: false,
        isSuccess: true,
        messagesList: messages2,
      ));
    });

    on<UnFlaggedMessagesEvent>((event, emit) async {
      bool res = await AggressorApi().unFlagMessages(
        event.messageId,
        event.contactId,
      );

      if (res) {
        state.messagesList![event.messageIndex].flagged = false;
      }

      emit(state.copyWith(
          isInitState: false,
          isLoading: false,
          isSuccess: true,
          messagesList: state.messagesList,
          msg: "Message UnFlagged successfully"));
    });

    on<FlaggedMessagesEvent>((event, emit) async {
      bool res = await AggressorApi().flagMessages(
        event.messageId,
        event.contactId,
      );

      if (res) {
        state.messagesList![event.messageIndex].flagged = true;
      }

      emit(
        state.copyWith(
          isInitState: false,
          isLoading: false,
          isSuccess: true,
          messagesList: state.messagesList,
          msg: "Message Flagged successfully",
        ),
      );
    });

    on<ViewedMessagesEvent>((event, emit) async {
      bool res = await AggressorApi().viewMessage(
        event.contactId,
        event.messageId,
      );
      if (res) {
        state.messagesList![event.messageIndex].opened = true;
      }
      emit(state.copyWith(
        isInitState: false,
        isLoading: false,
        isSuccess: true,
        messagesList: state.messagesList,
      ));
    });

    on<DeleteMessagesEvent>((event, emit) async {
      bool res = await AggressorApi().deleteMessage(
        event.contactId,
        event.messageId,
      );
      if (res) {
        state.messagesList!.removeAt(event.messageIndex);
        emit(state.copyWith(
          isInitState: false,
          isLoading: false,
          isSuccess: true,
          isDeleted: true,
          messagesList: state.messagesList,
          msg: "Message Deleted",
        ));
      } else {
        emit(state.copyWith(
          isInitState: false,
          isLoading: false,
          isSuccess: true,
          messagesList: state.messagesList,
          msg: "Message Not Deleted",
        ));
      }
    });
  }

  DateTime _getDateTime(String time, DateTime date) {
    try {
      // var x=DateTime.parse(date.toString().substring(0,10)+" "+time);
      return DateTime.parse(date.toString().substring(0, 10) + " " + time);
    } catch (e) {
      return date;
    }
  }
}
