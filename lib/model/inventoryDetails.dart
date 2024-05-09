class InventoryDetails {
  int? inventoryId;
  int? contactId;
  int? charterid;
  String? bunk;
  InventoryDetails(
      {this.inventoryId, this.contactId, this.bunk, this.charterid});

  InventoryDetails.fromJson(Map<String, dynamic> json) {
    inventoryId = json['inventoryid'];
    contactId = json['contactid'];
    charterid = json['charterid'];
    bunk = json['bunk'];
  }
}
