import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crypto/repositories/crypto_repository.dart';
import 'package:flutter_crypto/screens/home_screen.dart';

import 'blocs/crypto/crypto_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  /// BlockProvider is needed to access the created BloC
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CryptoBloc>(
      /// the underscore means we are not using a blocBuilder and is using default
      /// for the Bloc Class instantiation we can use the expand operator (..) so
      /// we can call a function within the class
      create: (_) => CryptoBloc(
        cryptoRepository: CryptoRepository(),
      )..add(AppStarted()),
      child: MaterialApp(
        title: 'Flutter Crypto App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.black,
          accentColor: Colors.redAccent[400],
        ),
        home: HomeScreen(),
      ),
    );
  }
}
