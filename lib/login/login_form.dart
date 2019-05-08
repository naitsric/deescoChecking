import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_deesco/authentication/authentication.dart';
import 'package:flutter_deesco/login/login.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class LoginForm extends StatefulWidget {
  final LoginBloc loginBloc;
  final AuthenticationBloc authenticationBloc;

  LoginForm({
    Key key,
    @required this.loginBloc,
    @required this.authenticationBloc,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginBloc get _loginBloc => widget.loginBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginEvent, LoginState>(
      bloc: _loginBloc,
      builder: (
          BuildContext context,
          LoginState state,
          ) {
        if (state is LoginFailure) {
          _onWidgetDidBuild(() {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          });
        }

        return Form(
          child:
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child:
                    Text(
                        "Bienvenido a DEESCO.co!!",
                      textScaleFactor: 1.4,
                    )
                ),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child:
                    TextFormField(
                      decoration: InputDecoration(labelText: 'email'),
                      controller: _usernameController,
                    )
                ),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child:
                    TextFormField(
                      decoration: InputDecoration(labelText: 'password'),
                      controller: _passwordController,
                      obscureText: true,
                    )
                ),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child:
                    RaisedButton(
                      onPressed:
                      state is! LoginLoading ? _onLoginButtonPressed : null,
                      child: Text('Ingresar'),
                    )
                ),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child:
                    Container(
                      child:
                      state is LoginLoading ? CircularProgressIndicator() : null,
                    )
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  _onLoginButtonPressed() {
    GraphQLClient client = GraphQLProvider.of(context).value;

    _loginBloc.dispatch(LoginButtonPressed(
        username: _usernameController.text,
        password: _passwordController.text,
        client: client
    ));
  }
}