import 'package:intl/intl.dart';
import 'package:knowledge_access_power/model/module_category.dart';
import 'package:knowledge_access_power/model/module_stage.dart';
import 'package:knowledge_access_power/model/study_module.dart';
import 'package:knowledge_access_power/model/user.dart';

class ParseApiData {
//MARK: parse the user data
  UserItem parseUser(var result) {
    String id = result["id"].toString();
    String email = result["email"].toString();
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
    );
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
    String video = getJsonData(result, "video");

    var moduleStage = ModuleStage(
      id: id,
      title: title,
      content: summary,
      contentVideo: video,
      noOfParticipants: "0",
      image: image,
    );
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

  String getJsonData(dynamic data, String key) {
    if (data == null || data[key] == null) {
      return "";
    }
    return data[key].toString();
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
