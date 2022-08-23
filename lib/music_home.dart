import 'package:flutter/material.dart';
import 'package:musiq_player/getSongs.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:musiq_player/new_box.dart';
import 'package:musiq_player/search_screen.dart';
import 'package:musiq_player/settings.dart';
import 'package:musiq_player/song_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'db/functions/db_fav.dart';
import 'fav_butn.dart';
import 'new_box.dart';

class _MusicHomeScreenState extends State<MusicHomeScreen> {
  @override
  void initState() {
    super.initState();
    requestPermission();
  }
  final _audioQuery = OnAudioQuery();

  // final AudioPlayer _audioPlayer = AudioPlayer();

  requestPermission() async{
    await Permission.storage.request();
    setState((){});
    // PermissionStatus status= await Permission.storage.request();
    // if(status.isDenied == true)
    // {
    //   requestPermission();
    // }
    // else\
    // {
    //   return true;
    // }
    // // setState((){});
    //
    }
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return SafeArea(
        child: Column(children: [
          // const SizedBox(
          //   height: 10,
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NewBox(
                child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchScreen()));
                    },
                    icon: const Icon(Icons.search)),
              ),
              RichText(
                text: const TextSpan(
                  text: 'MELODY',
                  style: TextStyle(
                    fontFamily:'KaushanScript',
                    fontSize: 23,
                    color: Colors.black,
                    // fontWeight: FontWeight.w600,
                  ),
                  children: [
                    TextSpan(
                      text: '\nBEATZ',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        // fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 55,
                width: 55,
                child: NewBox(
                    child: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SettingsScreen()));
                        },
                        icon: const Icon(Icons.settings_outlined))),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: FutureBuilder<List<SongModel>>(
                future: _audioQuery.querySongs(
                  sortType: null,
                  orderType: OrderType.ASC_OR_SMALLER,
                  uriType: UriType.EXTERNAL,
                  ignoreCase: true,
                ),
                builder: (context, items) {
                  if (items.data == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (items.data!.isEmpty) {
                    return const Center(child: Text('No Songs Found!',style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)));
                  }
                  MusicHomeScreen.song = items.data!;
                  if (!FavoriteDB.isInitialized) {
                    FavoriteDB.initialise(items.data!);
                  }
                  GetSongs.songscopy = items.data!;
                  return NewBox(
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          childAspectRatio: 1,
                        ),
                        itemCount: items.data!.length,
                        itemBuilder: (ctx, index) {
                          return GestureDetector(
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: NewBox(
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: QueryArtworkWidget(
                                        keepOldArtwork: true,
                                        id: items.data![index].id,
                                        type: ArtworkType.AUDIO,
                                        nullArtworkWidget: Image.asset(
                                          'assets/images/Melody.png',
                                          height: 300,
                                          width: 400,
                                          fit: BoxFit.cover,
                                        ),
                                        quality: 100,
                                        artworkBorder: BorderRadius.zero,
                                        // artworkClipBehavior: Clip.antiAliasWithSaveLayer,
                                        artworkFit: BoxFit.fill,
                                        artworkHeight: 300,
                                        artworkWidth: 400,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            children: [
                                              SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Text(
                                                    items.data![index]
                                                        .displayNameWOExt,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                              Text(
                                                items.data![index].artist
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              )
                                            ],
                                          ),
                                        ),
                                        FavoriteBut(
                                            song: MusicHomeScreen.song[index]),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              GetSongs.player.setAudioSource(
                                  GetSongs.createSongList(items.data!),
                                  initialIndex: index);
                              GetSongs.player.play();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SongPageScreen(
                                      playerSong: items.data!,
                                    ),
                                  ));
                              // playSong(items.data![index].uri);
                            },
                          );
                        }),
                  );
                }),
          ),
        ]),
      );
    });
  }
}

class MusicHomeScreen extends StatefulWidget {
  const MusicHomeScreen({Key? key}) : super(key: key);
  static List<SongModel> song = [];
  @override
  State<MusicHomeScreen> createState() => _MusicHomeScreenState();
}
