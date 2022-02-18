class ModuleCategory {
  String id = "";
  String title = "";

  ModuleCategory({
    this.id = "",
    this.title = "",
  });

  ModuleCategory.empty();
  // Convert a ModuleCategory into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title};
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'ModuleCategory{id: $id, title: $title';
  }
}
