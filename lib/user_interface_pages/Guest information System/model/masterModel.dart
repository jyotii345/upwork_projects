class MasterModel {
  int? id;
  String? title;
  String? abbv;
  List<MasterModel>? subCategories;
  bool isChecked;
  MasterModel(
      {this.id,
      this.title,
      this.abbv,
      this.isChecked = false,
      this.subCategories});
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MasterModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
