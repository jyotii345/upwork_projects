class MasterModel {
  int? id;
  String? title;
  String? abbv;
  MasterModel({this.id, this.title, this.abbv});
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MasterModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
