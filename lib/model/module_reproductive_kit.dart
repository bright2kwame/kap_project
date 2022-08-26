

class ReproductiveKitModule {
  String id = "";
  String title = "";
  String image = "";
  String description = "";
  String currency = "";
  String amount = "";
  String shopName = "";
  String shopImage = "";
  String shopLocation = "";
  String shopLat = "";
  String shopLon = "";
  

  ReproductiveKitModule({
    this.id = "",
    this.title = "",
    this.image = "",
    this.description = "",
    this.currency = "",
    this.amount = "",
    this.shopName = "0",
    this.shopImage = "",
    this.shopLocation = "",
    this.shopLat = "",
    this.shopLon = "",
  });

  ReproductiveKitModule.empty();
  // Convert a StudyModule into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'description': description,
      'currency': currency,
      'amount': amount,
      'shopName': shopName,
      'shopImage': shopImage,
      'shopLocation': shopLocation,
      'shopLat': shopLat,
      'shopLon': shopLon,
    };
  }

  // Implement toString to make it easier to see information about
  // each StudyModule when using the print statement.
  @override
  String toString() {
    return 'ReproductiveKitModule{id: $id, title: $title, description: $description}';
  }
}
