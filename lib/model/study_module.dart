import 'package:knowledge_access_power/model/module_stage.dart';

class StudyModule {
  String id = "";
  String title = "";
  String summary = "";
  String coverImage = "";
  String date = "";
  String moduleCategory = "";
  String noOfParticipants = "";
  String expiryDate = "";
  String noOfStages = "";

  StudyModule({
    this.id = "",
    this.title = "",
    this.summary = "",
    this.coverImage = "",
    this.date = "",
    this.noOfStages = "0",
    this.moduleCategory = "",
    this.noOfParticipants = "",
    this.expiryDate = "",
  });

  StudyModule.empty();
  // Convert a StudyModule into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'coverImage': coverImage,
      'date': date,
      'expiryDate': expiryDate,
      'moduleCategory': moduleCategory,
    };
  }

  // Implement toString to make it easier to see information about
  // each StudyModule when using the print statement.
  @override
  String toString() {
    return 'StudyModule{id: $id, title: $title, summary: $summary}';
  }
}
