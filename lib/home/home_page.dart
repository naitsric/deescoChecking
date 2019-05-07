import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_deesco/authentication/authentication.dart';
import 'package:flutter_deesco/deesco_graphql_client/main.dart';

import '../generate.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Deesco Checkin APP'),
      ),
      body: Center(
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
//              Padding(
//                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//                child: RaisedButton(
//                    color: Colors.blue,
//                    textColor: Colors.white,
//                    splashColor: Colors.blueGrey,
//                    onPressed: () {
//                      Navigator.push(
//                        context,
//                        MaterialPageRoute(builder: (context) => GenerateScreen()),
//                      );
//                    },
//                    child: const Text('GENERATE QR CODE')
//                ),
//              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    splashColor: Colors.blueGrey,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DeescoScanWidgetScreen()),
                      );
                    },
                    child: const Text('Scanear Código')
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    splashColor: Colors.blueGrey,
                    onPressed: () {
                      authenticationBloc.dispatch(LoggedOut());
                    },
                    child: const Text('Salir')
                ),
              ),
            ],
          )
      ),
    );
  }
}