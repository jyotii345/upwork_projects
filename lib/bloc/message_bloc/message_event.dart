part of 'message_bloc.dart';

@immutable
abstract class MessageEvent {}

class GetAllMessageEvent extends MessageEvent {
  final String contactId;
  final String userId;

  GetAllMessageEvent({required this.contactId,required this.userId});
}

class ReloadAllMessageEvent extends MessageEvent {
  final String contactId;
  final String userId;

  ReloadAllMessageEvent({required this.contactId,required this.userId});
}

class UnFlaggedMessagesEvent extends MessageEvent {
  final String contactId;
  final int messageId;
  final int messageIndex;

  UnFlaggedMessagesEvent({
    required this.contactId,
    required this.messageId,
    required this.messageIndex,
  });
}

class FlaggedMessagesEvent extends MessageEvent {
  final String contactId;
  final int messageId;
  final int messageIndex;

  FlaggedMessagesEvent({
    required this.contactId,
    required this.messageId,
    required this.messageIndex,
  });
}

class ViewedMessagesEvent extends MessageEvent {
  final String contactId;
  final int messageId;
  final int messageIndex;

  ViewedMessagesEvent({
    required this.contactId,
    required this.messageId,
    required this.messageIndex,
  });
}

class DeleteMessagesEvent extends MessageEvent {
  final String contactId;
  final int messageId;
  final int messageIndex;

  DeleteMessagesEvent({
    required this.contactId,
    required this.messageId,
    required this.messageIndex,
  });
}
