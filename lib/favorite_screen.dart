import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:musiq_player/db/functions/db_fav.dart';
import 'package:musiq_player/new_box.dart';
import 'package:musiq_player/song_page.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'getSongs.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  static ConcatenatingAudioSource createSongList(List<SongModel> song) {
    List<AudioSource> source = [];
    for (var songs in song) {
      source.add(AudioSource.uri(Uri.parse(songs.uri!)));
    }
    return ConcatenatingAudioSource(children: source);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: FavoriteDB.favoriteSongs,
        builder:
            (BuildContext context, List<SongModel> favorData, Widget? child) {
          return ListView(children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: NewBox(
                child: Text(
                  'L I K E D    S O N G S',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: FavoriteDB.favoriteSongs.value.isEmpty
                  ? Center(
                      child: Column(children: [
                        Lottie.asset(
                          'assets/images/EMPTY.json',
                          height: 200,
                          width: 200,
                        ),
                        const Text(
                          'No favorites found',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ]),
                    )
                  : ValueListenableBuilder(
                      valueListenable: FavoriteDB.favoriteSongs,
                      builder: (BuildContext ctx, List<SongModel> favorData,
                          Widget? child) {
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: favorData.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                          itemBuilder: (BuildContext context, int index) {
                            return NewBox(
                              child: ListTile(
                                onTap: () {
                                  FavoriteDB.favoriteSongs.notifyListeners();
                                  List<SongModel> newlist = [...favorData];

                                  GetSongs.player.setAudioSource(
                                      createSongList(newlist),
                                      initialIndex: index);
                                  GetSongs.player.play();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (ctx) => SongPageScreen(
                                            playerSong: newlist,
                                          )));
                                },
                                leading: QueryArtworkWidget(
                                  id: favorData[index].id,
                                  type: ArtworkType.AUDIO,
                                  nullArtworkWidget: Image.asset(
                                    'assets/images/Melody.png',
                                  ),
                                  artworkBorder: BorderRadius.zero,
                                ),
                                title: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    favorData[index].title,
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 14),
                                  ),
                                ),
                                subtitle: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    favorData[index].artist!,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Color.fromARGB(255, 0, 0, 0)),
                                  ),
                                ),
                                trailing: IconButton(
                                    onPressed: () {
                                      FavoriteDB.favoriteSongs
                                          .notifyListeners();
                                      FavoriteDB.delete(favorData[index].id);
                                    },
                                    icon: Icon(
                                      Icons.heart_broken_sharp,
                                      size: 30,
                                      color: Colors.red[300],
                                    )),
                              ),
                            );
                          },
                        );
                      }),
            ),
          ]);
        });
  }
}
