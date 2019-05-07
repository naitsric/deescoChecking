import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../graphql_operation/mutations/mutations.dart' as mutations;

const bool ENABLE_WEBSOCKETS = false;

class DeescoScanWidgetScreen extends StatelessWidget {
  const DeescoScanWidgetScreen() : super();

  @override
  Widget build(BuildContext context) {
    ValueNotifier client = GraphQLProvider.of(context);

    return GraphQLProvider(
      client: client,
      child: const CacheProvider(
        child: MyHomePage(title: 'GraphQL Widget'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key key,
    this.title,
  }) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int nRepositories = 50;
  String barcode = "";

  void changeQuery(String number) {
    setState(() {
      nRepositories = int.parse(number) ?? 50;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Mutation(
        options: MutationOptions(
          document: mutations.checkin,
        ),
        builder: (RunMutation toggleCheckIn, QueryResult result) {
          return Scaffold(
              appBar: new AppBar(
                title: new Text('Scanear código'),
              ),
              body: new Center(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: RaisedButton(
                          color: Colors.blue,
                          textColor: Colors.white,
                          splashColor: Colors.blueGrey,
                          onPressed: () async {
                            try {
                              String barcode = await BarcodeScanner.scan();
                              toggleCheckIn(
                                <String, dynamic>{
                                  'code': barcode,
                                }
                              );
                            } on PlatformException catch (e) {
                              if (e.code == BarcodeScanner.CameraAccessDenied) {
                                setState(() {
                                  this.barcode = 'The user did not grant the camera permission!';
                                });
                              } else {
                                setState(() => this.barcode = 'Unknown error: $e');
                              }
                            } on FormatException{
                              setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
                            } catch (e) {
                              setState(() => this.barcode = 'Unknown error: $e');
                            }
                          },
                          child: const Text('Iniciar Camara')
                      ),
                    )
                    ,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text(barcode, textAlign: TextAlign.center,),
                    )
                    ,
                  ],
                ),
              ));
        },
        update: (Cache cache, QueryResult result) {
          if (result.hasErrors) {
            print(['optimistic', result.errors]);
          }else{
            String wellcomeString = "Código invalido";
            if (result.data['action'] != null){
              wellcomeString = 'Bienvenid@, ${result.data['action']['person']['name']}';
            }
            setState(() => this.barcode = 'Bienvenida, $wellcomeString');
          }
          print(result);
        },
        onCompleted: (dynamic resultData) {
          print(resultData);
        }
    );
  }
}

