const String login = r'''
  mutation Login($email: String, $password: String) {
    action: login(email: $email, password: $password) {
      token
      user{
        id
        email
      }
    }
  }
''';
