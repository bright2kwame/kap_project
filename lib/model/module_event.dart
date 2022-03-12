class ModuleEvent {
  String id = "";
  String title = "";
  String image = "";
  String actionType = "";
  String message = "";
  String dateCreated = "";
  String startDate = "";
  String endDate = "";
  String longitude = "";
  String latitude = "";

  ModuleEvent(
      {this.id = "",
      this.title = "",
      this.image = "",
      this.dateCreated = "",
      this.actionType = "",
      this.message = "",
      this.startDate = "",
      this.latitude = "",
      this.longitude = "",
      this.endDate = ""});

  ModuleEvent.empty();
  // Convert a ModuleOptions into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title};
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'ModuleEvent{id: $id, title: $title';
  }
}
