import 'package:knowledge_access_power/model/module_options.dart';

class ModuleStage {
  String id = "";
  String title = "";
  String content = "";
  String image = "";
  String contentVideo = "";
  String noOfParticipants = "";
  bool hasCompleted = false;
  String moduleId = "";

  ModuleStage(
      {this.id = "",
      this.title = "",
      this.noOfParticipants = "",
      this.image = "",
      this.content = "",
      this.contentVideo = "",
      this.moduleId = "",
      this.hasCompleted = false});

  ModuleStage.empty();
  // Convert a ModuleStage into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }

  // Implement toString to make it easier to see information about
  // each StudyModule when using the print statement.
  @override
  String toString() {
    return 'ModuleStage{id: $id, title: $title}';
  }
}
