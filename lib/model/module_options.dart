class ModuleOptions {
  String id = "";
  String label = "";
  String image = "";

  ModuleOptions({
    this.id = "",
    this.label = "",
    this.image = "",
  });

  ModuleOptions.empty();
  // Convert a ModuleOptions into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {'id': id, 'label': label};
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'ModuleOptions{id: $id, label: $label';
  }
}
