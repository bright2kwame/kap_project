import 'package:knowledge_access_power/model/module_options.dart';

class ModuleStage {
  String id = "";
  String title = "";
  String content = "";
  String contentVideo = "";
  String noOfParticipants = "";
  List<ModuleOptions> questions = [];

  ModuleStage({this.id = "", this.title = "", this.noOfParticipants = ""});

  ModuleStage.empty();
  // Convert a ModuleStage into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'questions': questions,
    };
  }

  // Implement toString to make it easier to see information about
  // each StudyModule when using the print statement.
  @override
  String toString() {
    return 'ModuleStage{id: $id, title: $title}';
  }
}
