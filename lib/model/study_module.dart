import 'package:knowledge_access_power/model/module_stage.dart';

class StudyModule {
  String id = "";
  String title = "";
  String summary = "";
  String coverImage = "";
  String date = "";
  String moduleCategory = "";
  String noOfParticipants = "";
  bool isRewarded = false;
  bool hasQuizes = false;
  String expiryDate = "";
  List<ModuleStage> stages = [];

  StudyModule({
    this.id = "",
    this.title = "",
    this.summary = "",
    this.coverImage = "",
    this.date = "",
    this.moduleCategory = "",
    this.noOfParticipants = "",
    this.isRewarded = false,
    this.hasQuizes = true,
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
      'isRewarded': isRewarded,
      'hasQuizes': hasQuizes,
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
