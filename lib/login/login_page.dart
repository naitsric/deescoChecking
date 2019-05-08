import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

import 'package:flutter_deesco/authentication/authentication.dart';
import 'package:flutter_deesco/login/login.dart';

class LoginPage extends StatefulWidget {
  final UserRepository userRepository;

  LoginPage({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc _loginBloc;
  AuthenticationBloc _authenticationBloc;

  UserRepository get _userRepository => widget.userRepository;

  @override
  void initState() {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _loginBloc = LoginBloc(
      userRepository: _userRepository,
      authenticationBloc: _authenticationBloc,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("assets/bg/emmanuel-1234152-unsplash.jpg"),
            fit: BoxFit.cover,
          ),
          color: Colors.grey.shade200.withOpacity(0.5),
        ),
        child: new BackdropFilter(
          filter: new ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
          child: new Container(
            decoration: new BoxDecoration(color: Colors.black.withOpacity(0.2)),
            child: LoginForm(
              authenticationBloc: _authenticationBloc,
              loginBloc: _loginBloc,
            )
          ),
        )

      ),
    );
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }
}