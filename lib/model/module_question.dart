import 'package:knowledge_access_power/model/module_options.dart';

class ModuleQuestion {
  String id = "";
  String question = "";
  String type = "";
  List<ModuleOptions> options = [];
  List<String> selectedOption = [];

  ModuleQuestion({
    required this.id,
    required this.question,
    required this.type,
    required this.options,
  });

  ModuleQuestion.empty();
  // Convert a ModuleQuestion into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {'id': id, 'question': question};
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'ModuleQuestion{id: $id, question: $question';
  }
}
