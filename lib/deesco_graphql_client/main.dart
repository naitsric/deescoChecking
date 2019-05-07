import 'dart:async';

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
                                },
                                optimisticResult: {
                                  'action': {
                                    'code': barcode
                                  }
                                },
                              );
                              setState(() => this.barcode = barcode);
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
          print("138");
          if (result.hasErrors) {
            print(['optimistic', result.errors]);
          }
          print(result);
        },
        onCompleted: (dynamic resultData) {
          print("142");
          print(resultData);
        }
    );
  }
  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
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
  }
}
//
//class StarrableRepository extends StatelessWidget {
//  const StarrableRepository({
//    Key key,
//    @required this.repository,
//  }) : super(key: key);
//
//  final Map<String, Object> repository;
//
//  Map<String, Object> extractRepositoryData(Object data) {
//    final Map<String, Object> action =
//    (data as Map<String, Object>)['action'] as Map<String, Object>;
//    if (action == null) {
//      return null;
//    }
//    return action['starrable'] as Map<String, Object>;
//  }
//
//  bool get starred => repository['viewerHasStarred'] as bool;
//  bool get optimistic => (repository as LazyCacheMap).isOptimistic;
//
//  Map<String, dynamic> get expectedResult => <String, dynamic>{
//    'action': <String, dynamic>{
//      'starrable': <String, dynamic>{'viewerHasStarred': !starred}
//    }
//  };
//
//  @override
//  Widget build(BuildContext context) {
//    return Mutation(
//      options: MutationOptions(
//        document: starred ? mutations.removeStar : mutations.addStar,
//      ),
//      builder: (RunMutation toggleStar, QueryResult result) {
//        return ListTile(
//          leading: starred
//              ? const Icon(
//            Icons.star,
//            color: Colors.amber,
//          )
//              : const Icon(Icons.star_border),
//          trailing: result.loading || optimistic
//              ? const CircularProgressIndicator()
//              : null,
//          title: Text(repository['name'] as String),
//          onTap: () {
//            toggleStar(
//              <String, dynamic>{
//                'starrableId': repository['id'],
//              },
//              optimisticResult: expectedResult,
//            );
//          },
//        );
//      },
//      update: (Cache cache, QueryResult result) {
//        if (result.hasErrors) {
//          print(result.errors);
//        } else {
//          final Map<String, Object> updated =
//          Map<String, Object>.from(repository)
//            ..addAll(extractRepositoryData(result.data));
//          cache.write(typenameDataIdFromObject(updated), updated);
//        }
//      },
//      onCompleted: (dynamic resultData) {
//        showDialog<AlertDialog>(
//          context: context,
//          builder: (BuildContext context) {
//            return AlertDialog(
//              title: Text(
//                extractRepositoryData(resultData)['viewerHasStarred'] as bool
//                    ? 'Thanks for your star!'
//                    : 'Sorry you changed your mind!',
//              ),
//              actions: <Widget>[
//                SimpleDialogOption(
//                  child: const Text('DISMISS'),
//                  onPressed: () {
//                    Navigator.of(context).pop();
//                  },
//                )
//              ],
//            );
//          },
//        );
//      },
//    );
//  }
//}

