import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_cardy/game/edit_view.dart';
import 'package:flutter_cardy/game/favorite_view.dart';
import 'package:flutter_cardy/game/new_view.dart';
import 'package:flutter_cardy/game/game_view.dart';
import 'package:flutter_cardy/home/home_view.dart';
import 'package:flutter_cardy/auth/login_view.dart';
import 'package:flutter_cardy/auth/register_view.dart';

import 'package:flutter_cardy/util/storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

main() async {
  // Code ไว้เชื่อม firebase
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: Storage().islogin() ? "/home" : "/",
      // initialRoute: "/addVocabScreen",
      // initialRoute: "/showVocabGroupScreen",
      getPages: [
        GetPage(name: "/", page: () => Login()),
        GetPage(name: "/register", page: () => Register()),
        GetPage(name: "/home", page: () => Home()),
        GetPage(name: "/gameView", page: () => GameView()),
        GetPage(name: "/newGame", page: () => NewGame()),
        GetPage(name: "/editGame", page: () => EditGame()),
        GetPage(name: "/favoriteView", page: () => FavoriteView()),
        // GetPage(
        //   name: "/showVocabGroupScreen",
        //   page: () => ShowVocabGroupScreen(),
        // ),
        // GetPage(
        //   name: "/vocabListFutureScreen",
        //   page: () => VocabListFutureScreen(),
        // ),
        // GetPage(name: "/addVocabScreen", page: () => AddVocabScreen()),
      ],
    );
  }
}
