
import 'dart:convert';

List<Message> messageFromJson(String str) => List<Message>.from(json.decode(str).map((x) => Message.fromJson(x)));

String messageToJson(List<Message> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Message {
  Message({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.body,
    required this.messageBody,
    required this.opened,
    required this.flagged,
    required this.dateCreated,
    required this.timeCreated,
  });

  final int id;
  final String title;
  final String subTitle;
  final String body;
  final String messageBody;
   bool opened;
   bool flagged;DateTime dateCreated;
  final String timeCreated;

  factory Message.fromJson(json) => Message(
    id: json["id"],
    title: json["title"],
    subTitle: json["subTitle"],
    body: json["body"],
    messageBody: json["messageBody"],
    opened: json["opened"],
    flagged: json["flagged"],
    dateCreated: DateTime.parse(json["dateCreated"]),
    timeCreated: json["timeCreated"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "subTitle": subTitle,
    "body": body,
    "messageBody": messageBody,
    "opened": opened,
    "flagged": flagged,
    "dateCreated": "${dateCreated.year.toString().padLeft(4, '0')}-${dateCreated.month.toString().padLeft(2, '0')}-${dateCreated.day.toString().padLeft(2, '0')}",
    "timeCreated": timeCreated,
  };
}
