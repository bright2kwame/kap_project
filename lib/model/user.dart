class User {
  String id = "";
  String firstName = "";
  String lastName = "";
  String fullName = "";
  String email = "";
  String phone = "";
  String avatar = "";
  String token = "";
  String points = "";

  User(
      {this.id = "",
      this.firstName = "",
      this.lastName = "",
      this.fullName = "",
      this.email = "",
      this.phone = "",
      this.avatar = "",
      this.points = "0",
      this.token = ""});

  User.empty();
  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'token': token,
      'points': points,
    };
  }

  Map<String, dynamic> toPartialMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'points': points,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'User{id: $id, firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, token: $token, points: $points}';
  }
}
