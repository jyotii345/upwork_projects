part of 'message_bloc.dart';

class MessageState {
  final bool isLoading;
  final bool isInitState;
  final bool isError;
  final bool isSuccess;
  final bool isDeleted;
  final String msg;
  final String? timeZone;
  List<Message>? messagesList;

  MessageState({
    this.isLoading = false,
    this.isInitState = true,
    this.isError = false,
    this.isSuccess = false,
    this.isDeleted = false,
    this.msg = "",
    this.timeZone,
    this.messagesList,
  });

  MessageState copyWith({
    bool? isLoading,
    bool? isInitState,
    bool? isError,
    bool? isSuccess,
    bool? isDeleted,
    String? msg,
    String? timeZone,
    List<Message>? messagesList,
  }) {
    return MessageState(
      isLoading: isLoading ?? this.isLoading,
      isInitState: isInitState ?? this.isInitState,
      isError: isError ?? this.isError,
      isSuccess: isSuccess ?? this.isSuccess,
      isDeleted: isDeleted ?? false,
      msg: msg ?? "",
      timeZone: timeZone ?? this.timeZone,
      messagesList: messagesList ?? this.messagesList,
    );
  }
}
