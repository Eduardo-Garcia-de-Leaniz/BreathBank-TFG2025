class UserCredentials {
  final String email;
  final String password;

  UserCredentials({required this.email, required this.password});
}

class UserCredentialsRegister {
  final String email;
  final String password;
  final String confirmPassword;
  final String name;

  UserCredentialsRegister({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.name,
  });
}
