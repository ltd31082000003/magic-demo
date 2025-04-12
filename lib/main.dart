import 'package:flutter/material.dart';
import 'package:magic_sdk/magic_sdk.dart';
import 'package:magic_sdk/modules/blockchain/supported_blockchain.dart';
import 'login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    Magic.instance = Magic.custom('pk_live_616FEAA9EA2DD367', rpcUrl: 'https://polygon-rpc.com', chainId: 137);
    print('Magic.instance initialized successfully');
  } catch (e) {
    print('Error initializing Magic.instance: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Rendering Magic.instance.relayer');
    return MaterialApp(
      title: 'Magic Demo',
      home: Stack(children: [
        const LoginPage(),
        Magic.instance.relayer,
      ]),
    );
  }
}