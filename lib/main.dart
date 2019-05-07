import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

import 'package:flutter_deesco/authentication/authentication.dart';
import 'package:flutter_deesco/splash/splash.dart';
import 'package:flutter_deesco/login/login.dart';
import 'package:flutter_deesco/home/home.dart';
import 'package:flutter_deesco/common/common.dart';

//class SimpleBlocDelegate extends BlocDelegate {
//  @override
//  void onEvent(Bloc bloc, Object event) {
//    super.onEvent(bloc, event);
//    print(event);
//  }
//
//  @override
//  void onTransition(Bloc bloc, Transition transition) {
//    super.onTransition(bloc, transition);
//    print(transition);
//  }
//
//  @override
//  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
//    super.onError(bloc, error, stacktrace);
//    print(error);
//  }
//}

void main() {
  BlocSupervisor().delegate = BlocDelegate();
  runApp(MyApp(userRepository: UserRepository()));
}

class MyApp extends StatefulWidget {
  final UserRepository userRepository;

  MyApp({Key key, @required this.userRepository}) : super(key: key);

  @override
  State<MyApp> createState() => _AppState();
}

class _AppState extends State<MyApp> {
  AuthenticationBloc _authenticationBloc;
  UserRepository get _userRepository => widget.userRepository;

  @override
  void initState() {
    _authenticationBloc = AuthenticationBloc(userRepository: _userRepository);
    _authenticationBloc.dispatch(AppStarted());
    super.initState();
  }

  @override
  void dispose() {
    _authenticationBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      bloc: _authenticationBloc,
      child: MaterialApp(
        home: BlocBuilder<AuthenticationEvent, AuthenticationState>(
          bloc: _authenticationBloc,
          builder: (BuildContext context, AuthenticationState state) {
            if (state is AuthenticationUninitialized) {
              return SplashPage();
            }
            if (state is AuthenticationAuthenticated) {
              return HomePage();
            }
            if (state is AuthenticationUnauthenticated) {
              return LoginPage(userRepository: _userRepository);
            }
            if (state is AuthenticationLoading) {
              return LoadingIndicator();
            }
          },
        ),
      ),
    );
  }
}