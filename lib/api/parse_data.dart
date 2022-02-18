import 'package:intl/intl.dart';
import 'package:knowledge_access_power/model/user.dart';

class ParseApiData {
//MARK: parse the user data
  User parseUser(var result) {
    String id = result["id"].toString();
    String email = result["email"].toString();
    String lastName = result["last_name"].toString();
    String firstName = result["first_name"].toString();
    String fullName = lastName + " " + firstName;
    String phone = result["phone_number"].toString();
    String token = result["auth_token"].toString();
    String avatar = getJsonData(result, "profile_picture");
    String points = result["points"].toString();
    var user = User(
        id: id,
        firstName: firstName,
        lastName: lastName,
        fullName: fullName,
        email: email,
        phone: phone,
        avatar: avatar,
        points: points,
        token: token);
    return user;
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
