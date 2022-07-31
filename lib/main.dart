import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:musiq_player/db/model/music_player.dart';
import 'package:musiq_player/splash.dart';
import 'favorite_screen.dart';

// const String FAVORITES_BOX = 'favorites_box';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(MusicPlayerAdapter().typeId)) {
    Hive.registerAdapter(MusicPlayerAdapter());
  }
  await Hive.openBox<int>('favoriteDB');
  await Hive.openBox<MusicPlayer>('playlistDB');
//   await Hive.openBox(FAVORITES_BOX);

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MELODY',
      home: const Splash(),
      theme: ThemeData(
        primarySwatch: Colors.grey,
        fontFamily: 'KaushanScript'
      ),
      routes: {
        'favorites': (_) => const FavoriteScreen(),
      },
    );
  }
}
