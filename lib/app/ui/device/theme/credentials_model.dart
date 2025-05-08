class UserCredentialsModel {
  String? name;
  String email;
  String? password;

  UserCredentialsModel({
    this.name,
    required this.email,
    this.password,
  });

  factory UserCredentialsModel.fromMap(Map<String, dynamic> map) {
    return UserCredentialsModel(
      name: map['name'],
      email: map['email'],
      password: map['password'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
    };
  }
}
