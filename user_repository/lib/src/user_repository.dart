import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:meta/meta.dart';

import '../graphql_operation/mutations/mutations.dart' as mutations;

class UserRepository {
  Future<String> authenticate({
    @required String username,
    @required String password,
    @required GraphQLClient client,
  }) async {
//    Client client = GraphQLProvider.of(context).value;
    var login = await client.mutate(MutationOptions(
      document: mutations.login,
      variables: <String, dynamic>{
        'email': username,
        'password': password,
      },
    ));

    if (login.hasErrors) {
      throw("Wrong email or password");
    } else {
      await Future.delayed(Duration(seconds: 1));
      return login.data['action']['token'];
    }

  }

  Future<void> deleteToken() async {
    /// delete from keystore/keychain
    await FlutterKeychain.remove(key: "token");
    return;
  }

  Future<void> persistToken(String token) async {
    /// write to keystore/keychain
    await FlutterKeychain.put(key: "token", value: token);
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<bool> hasToken() async {
    var value = await FlutterKeychain.get(key: "token");
    bool bol = false;
    if(value  != null){
      bol = true;
    }
    return bol;
  }
}