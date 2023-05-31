part of 'contact_us_bloc.dart';

@immutable
abstract class ContactUsEvent {}

class ContactUsSendEmailEvent extends ContactUsEvent {
  final String fName;
  final String lName;
  final String email;
  final String body;

  ContactUsSendEmailEvent({
    required this.fName,
    required this.lName,
    required this.email,
    required this.body,
  });
}
