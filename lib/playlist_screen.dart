import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:musiq_player/new_box.dart';
import 'package:musiq_player/playlistSong.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'db/functions/db_playlist.dart';
import 'db/model/music_player.dart';

class PlaylistScreen extends StatefulWidget {
  PlaylistScreen({Key? key}) : super(key: key);

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

final nameController = TextEditingController();

class _PlaylistScreenState extends State<PlaylistScreen> {
  // late List<SongModel> playlistsong;
  late final MusicPlayer playlist;
  @override
  Widget build(BuildContext context) {
    // getAllPlaylist();
    return ValueListenableBuilder(
        valueListenable: Hive.box<MusicPlayer>('playlistDB').listenable(),
        builder:(BuildContext context,Box<MusicPlayer> musicList,
        Widget? child) {
          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  title: const NewBox(child: Text('P L A Y L I S T',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),),),),
                backgroundColor: Colors.transparent,
                body: NewBox(
                    child: Hive
                        .box<MusicPlayer>('playlistDB')
                        .isEmpty
                        ? Center(
                      child: Column(children: [
                        Lottie.asset(
                          'assets/images/EMPTY.json',
                          height: 200,
                          width: 200,
                        ),
                        const Text(
                          'No playlists found',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ]),
                    )

                        : ValueListenableBuilder(
                        valueListenable: Hive.box<MusicPlayer>('playlistDB')
                            .listenable(),
                        builder: (BuildContext context,
                            Box<MusicPlayer> musicList,
                            Widget? child) {
                          return GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                              itemCount: musicList.length,
                              itemBuilder: (BuildContext context, int index) {
                                final data = musicList.values.toList()[index];
                                return
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),

                                    child: InkWell(
                                      child: NewBox(
                                        // shape: RoundedRectangleBorder(
                                        //     borderRadius: BorderRadius.circular(25)),
                                        child: Card(
                                          elevation: 0,
                                          color: Colors.transparent,

                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(

                                                children: [
                                                  Expanded(
                                                    flex: 4,
                                                    child: SingleChildScrollView(
                                                        scrollDirection: Axis
                                                            .horizontal,
                                                        child: Text(
                                                          data.name,
                                                          style: const TextStyle(
                                                              fontSize: 15),
                                                        )),
                                                  ),


                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.delete_outlined,
                                                      size: 25,
                                                    ),
                                                    onPressed: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'Delete Playlist'),
                                                              content: const Text(
                                                                  'Are you sure you want to delete this playlist?'),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  child: const Text(
                                                                      'Yes'),
                                                                  onPressed: () {
                                                                    musicList
                                                                        .deleteAt(
                                                                        index);
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                                TextButton(
                                                                  child: const Text(
                                                                      'No'),
                                                                  onPressed: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                )
                                                              ],
                                                            );
                                                          });
                                                    },
                                                  ),
                                                ]),
                                          ),
                                        ),),
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                            builder: (context) {
                                              return PlaylistData(
                                                playlist: data,
                                                folderindex: index,
                                              );
                                            }));
                                      },
                                    ),
                                  );
                              });
                        })),


                floatingActionButton: ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          // playlistnotifier.notifyListeners();

                          return Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            child: SizedBox(
                              height: 250,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Center(
                                      child: Text(
                                        'Create Your Playlist',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    TextFormField(
                                        controller: nameController,
                                        decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: ' Playlist Name'),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Value is Empty";
                                          } else {
                                            return null;
                                          }
                                        }),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceEvenly,
                                      children: [
                                        SizedBox(
                                            width: 100.0,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: const Color
                                                        .fromARGB(
                                                        1, 200, 200, 200)),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Cancel'))

                                        ),
                                        SizedBox(
                                            width: 100.0,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: const Color
                                                      .fromARGB(
                                                      1, 200, 200, 200)),
                                              onPressed: () {
                                                whenButtonClicked();
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Save')) )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  },

                  // backgroundColor: Colors.grey,
                  child: const Icon(Icons.add),
                ),
              )
          );
        } );
  }

  Future<void> whenButtonClicked() async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      return;
    } else {
      final music = MusicPlayer(
        songIds: [],
        name: name,
      );
      playlistAdd(music);
      nameController.clear();
    }
  }
}
