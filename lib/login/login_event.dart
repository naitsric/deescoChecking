import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  LoginEvent([List props = const []]) : super(props);
}

class LoginButtonPressed extends LoginEvent {
  final String username;
  final String password;
  final GraphQLClient client;

  LoginButtonPressed({
    @required this.username,
    @required this.password,
    @required this.client,
  }) : super([username, password]);

  @override
  String toString() =>
      'LoginButtonPressed { username: $username, password: $password }';
}