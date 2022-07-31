import 'package:flutter/material.dart';
import 'package:musiq_player/db/functions/db_fav.dart';
import 'package:musiq_player/music_home.dart';
import 'package:musiq_player/new_box.dart';
import 'package:musiq_player/playlist_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'favorite_screen.dart';
import 'getSongs.dart';
import 'miniPlayer.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNav> {
  int currentIndex = 0;
  final screens = [
    const MusicHomeScreen(),
    const FavoriteScreen(),
    const PlaylistScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    return NewBox(

      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: IndexedStack(index: currentIndex, children: screens),
        bottomNavigationBar: ValueListenableBuilder(
          valueListenable: FavoriteDB.favoriteSongs,
          builder:
              (BuildContext context, List<SongModel> music, Widget? child) {
            return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (GetSongs.player.currentIndex != null)
                      Column(
                        children: const [
                          NewBox(
                              child: MiniPlayer()),
                          SizedBox(height: 10),
                        ],
                      )
                    else
                      const SizedBox(),
                    Container(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                      child: NewBox(

                        child: BottomNavigationBar(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          selectedItemColor: Colors.black,
                          selectedFontSize: 15,
                          unselectedItemColor:
                          const Color.fromRGBO(0, 0, 0, 0.38),
                          selectedIconTheme: const IconThemeData(
                              color: Colors.black),
                          showUnselectedLabels: false,
                          type: BottomNavigationBarType.fixed,
                          currentIndex: currentIndex,
                          onTap: (index) {
                            setState(() {
                              currentIndex = index;
                              FavoriteDB.favoriteSongs.notifyListeners();
                            });
                          },
                          items: const [
                            BottomNavigationBarItem(
                              icon: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: NewBox
                                  (child: Icon(Icons.home_outlined,size: 30,)),
                              ),
                              label: 'H O M E',
                            ),
                            BottomNavigationBarItem(
                              icon: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: NewBox
                                  (child: Icon(Icons.favorite_outline,size: 30,)),
                              ),
                              label: 'F A V O R I T E S',
                            ),
                            BottomNavigationBarItem(
                              icon: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: NewBox(child: Icon(Icons.playlist_add,size: 30,)),
                              ),
                              label: 'P L A Y L I S T',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ));
          },
        ),
      ),
    );
  }
}
