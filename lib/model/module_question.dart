import 'package:knowledge_access_power/model/module_options.dart';

class ModuleQuestion {
  String id = "";
  String questionText = "";
  String questionImage = "";
  String type = "";
  List<ModuleOptions> options = [];
  String selectedOption = "";
  bool markedCorrect = false;

  ModuleQuestion({
    this.id = "",
    this.questionText = "",
    this.questionImage = "",
    required this.options,
    this.type = "",
  });

  ModuleQuestion.empty();
  // Convert a ModuleQuestion into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {'id': id, 'questionText': questionText};
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'ModuleQuestion{id: $id, questionText: $questionText';
  }
}
