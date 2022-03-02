import 'package:intl/intl.dart';
import 'package:knowledge_access_power/model/module_category.dart';
import 'package:knowledge_access_power/model/module_event.dart';
import 'package:knowledge_access_power/model/module_options.dart';
import 'package:knowledge_access_power/model/module_question.dart';
import 'package:knowledge_access_power/model/module_stage.dart';
import 'package:knowledge_access_power/model/study_module.dart';
import 'package:knowledge_access_power/model/user.dart';

class ParseApiData {
//MARK: parse the user data
  UserItem parseUser(var result) {
    String id = result["id"].toString();
    String email = result["email"].toString();
    String username = result["username"].toString();
    String lastName = result["last_name"].toString();
    String firstName = result["first_name"].toString();
    String fullName = result["full_name"].toString();
    String phone = getJsonData(result, "phone_number");
    String token = result["auth_token"].toString();
    String badge = getJsonData(result, "badge");
    String avatar = getJsonData(result, "user_avatar");
    String points = getJsonData(result, "total_points");

    var user = UserItem(
        id: id,
        firstName: firstName,
        lastName: lastName,
        fullName: fullName,
        email: email,
        phone: phone,
        avatar: avatar,
        points: points,
        token: token,
        badge: badge,
        username: username);
    return user;
  }

  StudyModule parseModule(var result) {
    String id = result["id"].toString();
    String title = result["title"].toString();
    String summary = result["summary"].toString();
    String coverPhoto = getJsonData(result, "cover_photo");
    String noOfParticipants = getJsonData(result, "number_of_participants");
    String noOfSteps = getJsonData(result, "number_of_sub_modules");

    var studyModule = StudyModule(
        id: id,
        title: title,
        summary: summary,
        coverImage: coverPhoto,
        noOfStages: noOfSteps,
        noOfParticipants: noOfParticipants);
    return studyModule;
  }

  ModuleStage parseModuleStage(var result) {
    String id = result["id"].toString();
    String title = result["title"].toString();
    String summary = result["content"].toString();
    String image = getJsonData(result, "cover_photo");
    String noOfParticipants = getJsonData(result, "number_of_participants");
    String video = getJsonData(result, "video");
    String moduleId = getJsonData(result, "module_id");

    var moduleStage = ModuleStage(
        id: id,
        title: title,
        content: summary,
        contentVideo: video,
        noOfParticipants: noOfParticipants,
        image: image,
        moduleId: moduleId);
    return moduleStage;
  }

  ModuleCategory parseModuleCategory(var result) {
    String id = result["id"].toString();
    String title = result["title"].toString();
    var moduleCategory = ModuleCategory(
      id: id,
      title: title,
    );
    return moduleCategory;
  }

  ModuleOptions parseModuleOptions(var result) {
    String id = result["id"].toString();
    String answer = result["answer"].toString();
    String image = getJsonData(result, "image");
    String answerType = getJsonData(result, "answer_type");
    bool isScorrect = getJsonBoolData(result, "is_correct");
    var option =
        ModuleOptions(id: id, label: answer, image: image, type: answerType);
    option.isCorrect = isScorrect;
    return option;
  }

  ModuleQuestion parseModuleQuestion(var result) {
    String id = result["id"].toString();
    String description = result["description"].toString();
    String questionType = result["question_type"].toString();
    String image = getJsonData(result, "cover_photo");
    List<ModuleOptions> options = [];
    result["answers"].forEach((data) {
      ModuleOptions moduleOptions = parseModuleOptions(data);
      options.add(moduleOptions);
    });
    var moduleQuestion = ModuleQuestion(
        id: id,
        questionText: description,
        type: questionType,
        options: options,
        questionImage: image);
    return moduleQuestion;
  }

  ModuleQuestion parseSchemeQuestion(var result) {
    ModuleQuestion moduleQuestion = parseModuleQuestion(result["question"]);
    moduleQuestion.markedCorrect = result["is_correct"];
    var answerChosen = result["answer"];
    moduleQuestion.selectedOption = answerChosen["id"].toString();
    return moduleQuestion;
  }

  ModuleEvent parseEvent(var result) {
    String id = result["id"].toString();
    String title = result["title"].toString();
    String date = parseApiDate(result["date_created"].toString());
    String description = result["description"].toString();
    String coverPhoto = getJsonData(result, "cover_photo");
    String type = getJsonData(result, "feed_type");

    var moduleEvent = ModuleEvent(
        id: id,
        title: title,
        message: description,
        image: coverPhoto,
        dateCreated: date,
        actionType: type);
    return moduleEvent;
  }

  String getJsonData(dynamic data, String key) {
    if (data == null || data[key] == null) {
      return "";
    }
    return data[key].toString();
  }

  bool getJsonBoolData(dynamic data, String key) {
    if (data == null || data[key] == null) {
      return false;
    }
    return data[key];
  }

  String parseApiDate(String dateTime) {
    final dateTimeParsed = DateTime.parse(dateTime);
    return DateFormat('dd/MM/yyyy, HH:mm a').format(dateTimeParsed);
  }

  String parseApiShortDate(String dateTime) {
    final dateTimeParsed = DateTime.parse(dateTime);
    return DateFormat('dd/MM/yyyy').format(dateTimeParsed);
  }
}
