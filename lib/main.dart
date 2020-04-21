import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:movie_app/blocs/bloc_provider.dart';
import 'package:movie_app/blocs/home_bloc.dart';
import 'package:movie_app/ui/screens/home.dart';

import 'resources.dart';
import 'resources/movie_repository.dart';

void setupDI() {
  GetIt.I.registerSingleton(Client());
  GetIt.I.registerSingleton(MovieDbProvider(
    apiKey: "a7b3c9975791294647265c71224a88ad",
    baseUrl: "https://api.themoviedb.org/3",
    language: "en-US",
    client: GetIt.I.get()
  ));
  GetIt.I.registerSingleton(MySQLProvider());
  GetIt.I.registerSingleton(MovieRepository(
    movieDbProvider: GetIt.I.get(),
    mySQLProvider: GetIt.I.get()
  ));
}
void main() {
  setupDI();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]).then((_) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) async {
      runApp(MyApp());
    });    
  });  
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Helvetica',
        backgroundColor: const Color(0xFFF8F8F8)
      ),
      home: BlocProvider<HomeBloc>(builder: (_, bloc){
        return bloc ?? HomeBloc();
      }, child: HomeScreen()),
    );
  }
}
